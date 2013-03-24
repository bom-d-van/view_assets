module ViewAssets
  module Manager
    require "view_assets"
    require "view_assets/finder/core"
    require "view_assets/packager/actions_map"

    class Map
      def draw
        map = { :vendor => {}, :lib => {}, :app => {} }

        # App
        # Application
        application_manifest = PathInfo.new("#{app_path}/#{asset_path}/application")
        app_covered_action = false
        if FileTest.exist?("#{application_manifest.abs}.#{ext}")
          map[:app][application_manifest.to_s] = finder.retrieve_manifest(application_manifest, { :shallow => true })
          covered_action = true
        end

        # Controllers and Actions
        actions = action_map.retrieve
        actions.each do |controller, actions|
          controller_manifest = PathInfo.new("#{app_path}/#{asset_path}/#{controller}/#{controller}")
          controller_convered_action = false
          if FileTest.exist?("#{controller_manifest.abs}.#{ext}")
            map[:app][controller_manifest.to_s] = finder.retrieve_manifest(controller_manifest, { :shallow => true })
            controller_convered_action = true
          end

          actions.each do |action|
            action_manifest = "#{app_path}/#{asset_path}/#{controller}/#{action}"
            map[:app][action_manifest] = finder.retrieve(controller, action, { :shallow => true })

            if controller_convered_action || app_covered_action
              map[:app][action_manifest][0] = map[:app][action_manifest][0].basename
            end
          end
        end

        # Vendor
        Pathname.new("#{root}/#{vendor_path}/#{asset_path}").children.each do |entry|
          manifest = PathInfo.new(entry.to_s).rel

          map[:vendor][manifest.basename] = finder.retrieve_manifest(manifest.rel, { :shallow => true })
        end

        # Lib
        Pathname.new("#{root}/#{lib_path}/#{asset_path}").children.each do |entry|
          manifest = PathInfo.new(entry.to_s).rel

          map[:lib][manifest.basename] = finder.retrieve_manifest(manifest.rel, { :shallow => true })
        end

        map
      end

      # def retrieve_manifests
      #   manifests = { :vendor => [], :lib => [], :app => [] }
      #
      #   # Vendor Assets
      #   manifests[:vendor] = retrieve_indexing_manifests("#{root}/#{vendor_path}/#{asset_path}")
      #   # lib Assets
      #   manifests[:lib] = retrieve_indexing_manifests("#{root}/#{lib_path}/#{asset_path}")
      #   # Application Asset
      #   manifests[:app].push(PathInfo.new("#{root}/#{app_path}/#{asset_path}/application.#{ext}"))
      #   # :controller/:action
      #   action_manifests = []
      #   Pathname.new("#{root}/#{app_path}/#{asset_path}").children.each { |controller|
      #     if controller.directory?
      #       action_manifests.concat(retrieve_indexing_manifests(controller))
      #     end
      #   }
      #   manifests[:app].concat(action_manifests)
      #
      #   # Remove Filename Extensions
      #   manifests.each do |type, manifest_col|
      #     manifests[type] = manifest_col.map do |manifest|
      #       manifest.with_ext? ? manifest.chomp(File.extname(manifest)) : manifest
      #     end
      #   end
      # end
      #
      # def retrieve_indexing_manifests(path)
      #   Pathname.new(path).children.each_with_object([]) do |entry, manifests|
      #     if entry.file?
      #       manifests.push(PathInfo.new(entry.to_s))
      #     elsif entry.children.include?(entry.join("index.#{ext}"))
      #       manifests.push(PathInfo.new(entry.join("index.#{ext}").to_s))
      #     end
      #   end
      # end
      #
      def root
        Rails.public_path
      end

      def app_path
        ::ViewAssets::APP_FOLDER
      end

      def vendor_path
        ::ViewAssets::VENDOR_FOLDER
      end

      def lib_path
        ::ViewAssets::LIB_FOLDER
      end
    end

    class JsMap < Map
      def ext
        JS_EXT
      end

      def asset_path
        JS_PATH
      end

      def action_map
        ::ViewAssets::Packager::JsActionsMap.new
      end

      def finder
        ::ViewAssets::Finder::JsFinder.new
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