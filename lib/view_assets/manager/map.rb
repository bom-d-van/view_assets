module ViewAssets
  module Manager
    class Map
      def draw
        map = { :vendor => {}, :lib => {}, :app => {} }

        # App
        # Application
        application_manifest = PathInfo.new("#{app_path}/#{asset_path}/application")
        app_covered_action = false
        if FileTest.exist?("#{application_manifest.abs}.#{ext}")
          map[:app][application_manifest.to_s] = finder.retrieve_manifest(application_manifest, { :shallow => true })
          app_covered_action = true
        end

        # Controllers and Actions
        actions = action_map.retrieve
        actions.each do |controller, actions|
          controller_manifest = PathInfo.new("#{app_path}/#{asset_path}/#{controller}/#{controller}")
          controller_convered_action = false
          if FileTest.exist?("#{controller_manifest.abs}.#{ext}")
            map[:app][controller_manifest.to_s] = finder.retrieve_manifest(controller_manifest, { :shallow => true, :controller => controller })

            controller_convered_action = true
          end

          actions.each do |action|
            action_manifest = "#{app_path}/#{asset_path}/#{controller}/#{action}"
            map[:app][action_manifest] = finder.retrieve(controller, action, { :shallow => true, :controller => controller, :action => action })

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

        FileUtils.mkdir_p("#{root}/assets")
        File.open("#{root}/assets/#{asset_path}_assets.yml", 'w') { |file| file << YAML.dump(map) }

        map
      end

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

      def action_map
        ::ViewAssets::Packager::CssActionsMap.new
      end

      def finder
        ::ViewAssets::Finder::CssFinder.new
      end
    end
  end
end