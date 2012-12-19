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
  class AssetsFinder < Struct.new(:root, :controller_name, :action_name)
    # attr_reader :root, :controller_name, :action_name
    # def initialize(root, controller_name, action_name)
    #   @root = root
    #   @controller_name = controller_name
    #   @action_name = action_name
    #   
    #   # action manifest file
    #   # controller_path = "#{assets_path}/#{controller_name}/"
    #   # action_file = "#{controller_path}/#{action_name}.#{asset_extension}"
    #   # action_index = "#{controller_path}/#{action_name}/index.#{asset_extension}"
    #   # if FileTest.exist? action_file
    #   #   @manifest_files.push action_file
    #   # elsif FileTest.exist? action_index
    #   #   @manifest_files.push action_index
    #   # end
    # end
    
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
      # TODO it just feel so weird to verify your asset in a GET method
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
      application_manifest = "#{root}/#{app_path}/application.#{asset_extension}"
      controller_manifest = "#{root}/#{app_path}/#{controller_name}.#{asset_extension}"
      
      manifest = nil
      manifest = application_manifest if FileTest.exist?(application_manifest)
      manifest = controller_manifest if FileTest.exist?(controller_manifest)
      
      manifest.nil? ? [] : retrieve_assets(manifest)
    end
    
    # If the action assets is only a file, finder will also consider it a
    # manifest file.
    # If the action assets is a foler consisting several asset files, finder will
    # includes all the assets inside this folder. Among these files, a file named
    # index.[js|css] will be taken as manifest file.
    def action_assets
      action_path = "#{root}/#{app_path}/#{controller_name}"
      single_action_path = "#{action_path}/#{action_name}.#{asset_extension}"
      indexed_action_path = "#{action_path}/#{action_name}/index.#{asset_extension}"

      # find files in the conventional directory
      manifest = nil
      manifest = single_action_path if FileTest.exist?(single_action_path)
      manifest = indexed_action_path if FileTest.exist?(indexed_action_path)
      
      manifest.nil? ? [] : retrieve_assets(manifest)
    end

    private
    
    def retrieve_assets(manifest)
      assets = []
      directive = Directive.new(asset_type)

      Pathname.new(manifest).each_line do |line|
        # break if directive.ending_directive?(l) # TODO add ending_directive support
        next unless directive.legal_directive?(line)
        assets.concat(analyze(*directive.parse(line)))
      end

      assets
    end
    
    def analyze(asset_category, path_params)
      case asset_category
      when 'vendor'
        path_params.map { |pp| retrieve_vendor_assets(pp) }
      when 'lib'
        path_params.map { |pp| retrieve_lib_assets(pp) }
      when 'app'
        path_params.map { |pp| retrieve_app_assets(pp) }
      end
    end
    
    # def retrieve_app_assets(assets)
    def retrieve_app_assets(manifest)
      # relatively_pathize(app_path, assets)
      meta_retrieve(app_path, manifest)
    end
    
    def retrieve_vendor_assets(manifest)
      meta_retrieve(vendor_path, manifest)
    end
    
    def retrieve_lib_assets(manifest)
      meta_retrieve(lib_path, manifest)
    end
    
    # for lib and vendor assets, finder will assume that it was stored in the
    # root of vendor|lib and the file itself is a manifest file at first. If
    # that isn't the case, finder will try to locate it in
    # vendor|lib/:lib_or_vendor_name and take index.js inside that folder as
    # manifest.
    def meta_retrieve(manifest_path, manifest)
      single_file_lib = absolutely_pathize(manifest_path, manifest)
      
      lib_dir = "#{manifest_path}/#{manifest}"
      indexing_lib = absolutely_pathize(lib_dir, 'index')
      other_files_apart_from_manifest = []
      
      real_manifest = nil
      if FileTest.exist?(single_file_lib)
        real_manifest = single_file_lib
      else FileTest.exist?(indexing_lib)
        real_manifest = indexing_lib
        other_files_apart_from_manifest = retrieve_all_from(lib_dir)
      end
      
      retrieve_assets(real_manifest).flatten
                                    .concat(other_files_apart_from_manifest)
                                    .concat([unabsolutely_pathize(real_manifest)])
                                    .uniq
    end
    
    # TODO add test for dir should be a relative path
    def retrieve_all_from(dir)
      Dir["#{root}/#{dir}/**/*.#{asset_extension}"].map { |file| unabsolutely_pathize(file) }
    end
    
    def relatively_pathize(asset_dir, asset)
      "#{asset_dir}/#{asset.match(/\.#{asset_extension}$/) ? asset : "#{asset}.js"}"
    end
    
    # TODO add tests
    def app_path
      "app/#{assets_path}"
    end
    
    # TODO add tests
    def lib_path
      "lib/#{assets_path}"
    end
    
    # TODO add tests
    def vendor_path
      "vendor/#{assets_path}"
    end
    
    def absolutely_pathize(asset_dir, asset)
      "#{root}/#{asset_dir}/#{asset}.#{asset_extension}"
    end

    # def complete_paths_of_assets(directive_params, is_tree_directive)
    #   if is_tree_directive  # get all js file names in directory
    #     directive_params = [directive_params] unless directive_params.kind_of? Array
    #     raise ConfigurationError.new("params of require_tree must be a String") unless directive_params.all? { |dp| dp.kind_of? String }
    #     directive_params.map { |dp| Dir.glob("#{assets_path}/#{dp}/**/*.#{asset_extension}") }
    #   elsif directive_params.last.kind_of? Array  # get target js files in directory
    #     directive_params.last.map { |d|
    #       "#{assets_path}/#{directive_params.first}/#{d}"
    #     }
    #   else  # get a target js files in directory
    #     [directive_params].flatten.map { |d| "#{assets_path}/#{d}" }
    #   end
    # end

    def unabsolutize_asset_path(asset_path)
      asset_path.partition('public')[2]
    end

    def verify_asset(asset)
      # raise AssetsMvcError.new("File #{asset} DOEST EXIST") if FileTest.exist?(asset)
    end
  end
end