##
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
  ##
  # It's an abstract class.
  class AssetsFinder < Struct.new(:root, :controller_name, :action_name)
    
    def initialize(*args)
      @all_assets = []
      @retrieved = false
      
      super(*args)
    end
    
    # todo try to figure out what really is DUCK TYPING
    # tag method should be overrided by subclass
    # def tag
    #   raise UnimplementedError.new "tag method is unimplemented."
    # end

    ##
    # This method is the ENTRY of assets finder after its initializtion.
    # It returns all asset paths wrapped inside a appropriated html
    # tag(`script` | `link`).
    def all
      all_assets.map { |asset| tag asset } # tag should be realized in a subclass
    end

    ##
    # get all the asset paths in full path
    # TODO realize this method
    def full
      all_assets.map { |asset| absolutely_pathize(asset) }
    end

    ##
    # "untagged" means hasn't been wrapped inside a appropriated html tag like
    # `script` or `link`
    def all_assets
      retrieve unless retrieved?

      verify if TO_VERIFY
      
      @all_assets
    end
    
    # TODO document
    def retrieve
      @all_assets = controller_assets.concat(action_assets).uniq if @all_assets.empty?
      @retrieved = true
    end
    
    # TODO document
    def retrieved?
      @retrieved
    end
    
    ##
    # Check out whether all assets is existed or not
    # It is better to be turned off in production
    def verify
      all_assets.each do |asset| 
        asset_file = absolutely_pathize(asset)
        raise AssetNotFound.new("File #{ asset } DOEST EXIST") if FileTest.exist?(asset_file)
      end
    end

    ##
    # The env assets are assets that will be required before action assets.
    # The function of env assets is to allow user to require some assets
    # that would be used throughout the whole application or controller.
    # Like views in rails, assets finder will use application.[js|css] existed
    # in /app/assets/[javascripts|stylesheets] folder if:controller.[js|css]
    # in /app/assets/[javascripts|stylesheets]/:controller is not existed.
    def controller_assets
      return @controller_assets unless @controller_assets.nil?
      
      @controller_assets = []
      application_manifest = "#{ root }/#{ app_path }/application.#{ asset_extension }"
      controller_manifest = "#{ root }/#{ app_path }/#{ controller_name }/#{ controller_name }.#{ asset_extension }"

      manifest = nil
      manifest = application_manifest if FileTest.exist?(application_manifest)
      manifest = controller_manifest if FileTest.exist?(controller_manifest)
      
      # TODO add rspec example
      return @controller_assets if manifest.nil?

      @controller_assets = manifest.nil? ? [] : retrieve_assets_from(manifest)
      @controller_assets << unabsolutely_pathize(manifest)
    end

    ##
    # If the action assets is only a file, finder will also consider it a
    # manifest file.
    # If the action assets is a foler consisting several asset files, finder will
    # includes all the assets inside this folder. Among these files, a file named
    # index.[js|css] will be taken as manifest file.
    def action_assets
      return @action_assets unless @action_assets.nil?
      
      @action_assets = []
      action_path = "#{ root }/#{ app_path }/#{ controller_name }"
      single_action_path = "#{ action_path }/#{ action_name }.#{ asset_extension }"
      indexed_action_path = "#{ action_path }/#{ action_name }/index.#{ asset_extension }"

      # find files in the conventional directory
      manifest = nil
      manifest = single_action_path if FileTest.exist?(single_action_path)
      manifest = indexed_action_path if FileTest.exist?(indexed_action_path)

      # TODO add rspec example
      return @action_assets if manifest.nil?

      @action_assets = manifest.nil? ? [] : retrieve_assets_from(manifest)
      @action_assets << unabsolutely_pathize(manifest)
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
      
      # TODO find another way to realize this instead of using "flatten" method
      assets.flatten
    end
    
    def analyze(asset_category, path_params)
      case asset_category
      when 'vendor'
        path_params.map { |pp| retrieve_vendor_assets(pp) }
      when 'lib'
        path_params.map { |pp| retrieve_lib_assets(pp) }
      when 'app'
        path_params.map { |pp| retrieve_app_asset(pp) }
      end
    end
    
    # def retrieve_app_assets(assets)
    def retrieve_app_asset(required_asset)
      # relatively_pathize(app_path, assets)
      # meta_retrieve(app_path, manifest)
      # manifest_assets = []
      asset_path = "#{ app_path }#{ required_asset.match(/^\//) ? '' : "/#{ controller_name }" }"
      # asset = "#{ required_asset }"
      relatively_pathize(asset_path, required_asset.gsub(/^\//, ''))
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
    # 
    # NOTE: All assets returned will be "unabsolutely_pathized" here. That
    #       means each string of file path does not contain any root path info.
    def meta_retrieve(manifest_path, manifest)
      single_file_lib = absolutely_pathize(manifest_path, manifest)
      
      manifest_dir = "#{ manifest_path }/#{ manifest }"
      indexing_lib = absolutely_pathize(manifest_dir, 'index')
      other_files_apart_from_manifest = []
      
      real_manifest = nil
      if FileTest.exist?(single_file_lib)
        real_manifest = single_file_lib
      else FileTest.exist?(indexing_lib)
        real_manifest = indexing_lib
        all_assets_in_manifest_dir = retrieve_all_from(manifest_dir)
      end
      
      retrieve_assets(real_manifest).flatten
                                    .concat(all_assets_in_manifest_dir)
                                    .concat([unabsolutely_pathize(real_manifest)])
                                    .uniq
    end
    
    # TODO add test for dir should be a relative path
    def retrieve_all_from(dir)
      Dir["#{ root }/#{ dir }/**/*.#{ asset_extension }"].map { |file| unabsolutely_pathize(file) }
    end
    
    def relatively_pathize(asset_dir, asset)
      "#{ asset_dir }/#{ asset.match(/\.#{ asset_extension }$/) ? asset : "#{ asset }.js" }"
    end
    
    # TODO add tests
    def app_path
      "app/#{ assets_path }"
    end
    
    # TODO add tests
    def lib_path
      "lib/#{ assets_path }"
    end
    
    # TODO add tests
    def vendor_path
      "vendor/#{ assets_path }"
    end
    
    def absolutely_pathize(asset_dir, asset)
      "#{ root }/#{ asset_dir }/#{ asset.match(/\.#{ asset_extension }$/) ? asset : "#{ asset }.js" }"
    end
    
    def unabsolutely_pathize(asset_path)
      asset_path.gsub(/^#{ root }\//, '')
    end

    # def complete_paths_of_assets(directive_params, is_tree_directive)
    #   if is_tree_directive  # get all js file names in directory
    #     directive_params = [directive_params] unless directive_params.kind_of? Array
    #     raise ConfigurationError.new("params of require_tree must be a String") unless directive_params.all? { |dp| dp.kind_of? String }
    #     directive_params.map { |dp| Dir.glob("#{ assets_path }/#{ dp }/**/*.#{ asset_extension }") }
    #   elsif directive_params.last.kind_of? Array  # get target js files in directory
    #     directive_params.last.map { |d|
    #       "#{ assets_path }/#{ directive_params.first }/#{ d }"
    #     }
    #   else  # get a target js files in directory
    #     [directive_params].flatten.map { |d| "#{ assets_path }/#{ d }" }
    #   end
    # end

    def unabsolutize_asset_path(asset_path)
      asset_path.partition('public')[2]
    end

    def verify_asset(asset)
      # raise AssetsMvcError.new("File #{ asset } DOEST EXIST") if FileTest.exist?(asset)
    end
  end
end