# Manifest file is a file that contains some dependency directives on top
# of it. Finder will parse these directives if existed and include them
# in the html.
# Usually, the first manifest file will be application.[js|css] in 
# /app/assets/[javascripts|stylesheets] folder. However, if there is a
# :controller.[js|css] file existed in /app/assets/:controller folder,
# then it will replace application as the first manifest file. 
# It will append assets dependency before every action assets.
# If both application and :controller manifest file are not existed,
# then the manifest file list will be empty at first.

module ViewAssets
  # It's an abstract class.
  class AssetsFinder
    attr_reader :root, :controller_name, :action_name
    def initialize(root, controller_name, action_name)
      @root = root
      @controller_name = controller_name
      @action_name = action_name
      
      # action manifest file
      # controller_path = "#{assets_path}/#{controller_name}/"
      # action_file = "#{controller_path}/#{action_name}.#{asset_extension}"
      # action_index = "#{controller_path}/#{action_name}/index.#{asset_extension}"
      # if FileTest.exist? action_file
      #   @manifest_files.push action_file
      # elsif FileTest.exist? action_index
      #   @manifest_files.push action_index
      # end
    end
    
    # This method is the ENTRY of assets finder after its initializtion.
    # It returns all asset paths wrapped inside a appropriated html 
    # tag(`script` | `link`).
    def all
      all_untagged_assets.map do |asset|
        tag unabsolutize_asset_path(asset) # should be realized in a subclass
      end
    end
    
    # tag method should be overrided by subclass
    # def tag
    #   raise UnimplementedError.new "tag method is unimplemented."
    # end
    
    # untagged => hasn't been wrapped inside a appropriated html tag like 
    # `script` or `link`
    def all_untagged_assets
      # todo => it just feel so weird to verify your asset in a GET method
      @all_assets ||= app_assets.concat(action_assets).map { |a| verify_asset(a); a }
    end
    
    # def root_path
    #   Rails.public_path
    # end

    # def app_assets
    #   Dir.glob("#{assets_path}/app/**/*.#{asset_extension}")
    # end
    
    # The env assets are assets that will be required before action assets.
    # The function of env assets is to allow user to require some assets
    # that would be used throughout the whole application or controller.
    # Like views in rails, assets finder will use application.[js|css] existed
    # in /app/assets/[javascripts|stylesheets] folder if:controller.[js|css]
    # in /app/assets/[javascripts|stylesheets]/:controller is not existed.
    def controller_assets
      application_manifest = "#{assets_path}/application.#{asset_extension}"
      controller_manifest = "#{assets_path}/#{controller_name}.#{asset_extension}"
      if FileTest.exist? controller_manifest
        
      elsif FileTest.exist? application_manifest
        
      end
    end
    
    # If the action assets is only a file, finder will also consider it a
    # manifest file.
    # If the action assets is a foler consisting several asset files, finder will
    # includes all the assets inside this folder. Among these files, a file named
    # index.[js|css] will be taken as manifest file.
    def action_assets
      manifest_file, assets = '', []
      action_path = "#{assets_path}/#{controller_name}/#{action_name}"

      # find files in the conventional directory
      if FileTest.exist?(action_path + ".#{asset_extension}")
        manifest_file = action_path + ".#{asset_extension}"
        assets.push manifest_file
      else
        manifest_file = "#{action_path}/index.#{asset_extension}"
        assets = Dir.glob("#{action_path}/**/*.#{asset_extension}")
      end
      dependent_assets = retrieve_assets(manifest_file)  # detect and parse extra-included-files directives

      dependent_assets.concat assets
    end

    private
      def retrieve_assets(manifest)
        assets = []

        Pathname.new(file).each_line(manifest) do |l|
          # if l.match(all_directives)
          #   directive_params = []
          #   eval "directive_params = " + l.gsub(all_directives, '')
          #   is_tree_directive = !l.match(tree_directive).nil?
          # 
          #   assets.push complete_paths_of_assets(directive_params, is_tree_directive)
          # else
          #   break
          # end
        end

        assets.flatten
      end

      def complete_paths_of_assets(directive_params, is_tree_directive)
        if is_tree_directive  # get all js file names in directory
          directive_params = [directive_params] unless directive_params.kind_of? Array
          raise ConfigurationError.new("params of require_tree must be a String") unless directive_params.all? { |dp| dp.kind_of? String }
          directive_params.map { |dp| Dir.glob("#{assets_path}/#{dp}/**/*.#{asset_extension}") }
        elsif directive_params.last.kind_of? Array  # get target js files in directory
          directive_params.last.map { |d|
            "#{assets_path}/#{directive_params.first}/#{d}"
          }
        else  # get a target js files in directory
          [directive_params].flatten.map { |d| "#{assets_path}/#{d}" }
        end
      end

      def unabsolutize_asset_path(asset_path)
        asset_path.partition('public')[2]
      end

      def verify_asset(asset)
        # raise AssetsMvcError.new("File #{asset} DOEST EXIST") if FileTest.exist?(asset)
      end
  end
end