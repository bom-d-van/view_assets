module ViewAssets
  module Manager
    require "view_assets"
    require "view_assets/finder/directive"

    class Map
      def generate(option)
        option ||= {}
        option = { :asset_sep => true, :folder_sep => true }.update(option)

        manifests = retrieve_manifests
      end

      def retrieve_manifests
        assets = { :vendor => [], :lib => [], :app => [] }
        # vendor
        asests[:vendor] = retrieve_indexing_manifest("#{root}/#{VENDOR_FOLDER}/#{asset_path}")

        # lib
        assets[:lib] = retrieve_indexing_manifest("#{root}/#{LIB_FOLDER}/#{asset_path}")

        # application.ext
        assets[:app] = "#{root}/#{APP_FOLDER}/#{asset_path}/application.#{ext}"

        # :controller/:action
        action_manifests = []
        Pathname.new("#{root}/#{APP_FOLDER}/#{asset_path}").children.each { |controller|
          if controller.directory?
            action_manifests.concat retrieve_indexing_manifests(controller)
          end
        }

        assets[:app].concat(action_manifests)
      end

      def retrieve_indexing_manifests(path)
        Pathname.new(path).children.each_with_object([]) do |manifests, entry|
          if entry.file?
            manifests.push(PathInfo.new(entry.to_s))
          elsif entry.children.include?(entry.join("index.#{ext}"))
            manifest.push(PathInfo.new(entry.join("index.#{ext}")))
          end
        end
      end

      def root
        Rails.public_path
      end
    end

    class JsMap < Map
      def ext
        JS_EXT
      end

      def asset_path
        JS_PATH
      end
    end

    class CssMap < Map
      def ext
        CSS_EXT
      end

      def asset_path
        CSS_PATH
      end
    end
  end
end