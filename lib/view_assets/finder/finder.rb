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
  module Finder
    class Finder
      attr_accessor :controller, :action, :assets
      def initialize
        @controller = ''
        @action = ''
        @assets = []
      end
      
      ##
      # This method is the ENTRY of assets finder after its initializtion.
      # It returns all asset paths wrapped inside a appropriated html
      # tag(`script` | `link`).
      # options
      # :controller => nil
      # :action => nil
      # :full => false
      # :tagged => false
      # TODO: remove this quick fix used for adding a leading slash to make 
      def retrieve(options = {})
        options[:full] ||= false
        options[:tagged] ||= false
        
        assets = []
        controller = options[:controller] unless options[:controller].nil?
        action = options[:action] unless options[:action]
        
        retrieve_controller_assets
        retrieve_action_assets
        assets.uniq!
        
        assets.map! { |(assPathInfo.newetize).relasset) } if options[:full]
        
        all_assets.map { |asset| tag "/#{asset}" } if options[:tagged]
        
        assets
      end

      private
    
      ##
      # Check out whether all assets is existed or not
      # It is better to be turned off in production
      def verify
        all_assets.each do |asset| 
          raise AssetNotFound.new("File #{asset} DOEST EXIST") unless FileTest.exist?(asset.abs)
        end
      end

      ##
      # The env assets will be required before action assets.
      # The function of env assets is to allow user to require some assets
      # that would be used throughout the whole application or controller.
      # Like views in rails, assets finder will use application.[js|css] existed
      # in /app/assets/[javascripts|stylesheets] folder if:controller.[js|css]
      # in /app/assets/[javascripts|stylesheets]/:controller is not existed.
      def retrieve_controller_assets
        application_manifest = PathInfo.new("#{app_path.to_s}/application.#{asset_extension}")
        controller_manifest = PathInfo.new("#{app_path.to_s}/#{controller}/#{controller}.#{asset_extension}")

        manifest = nil
        manifest = application_manifest if FileTest.exist?(application_manifest)
        manifest = controller_manifest if FileTest.exist?(controller_manifest)
      
        # TODO add rspec example
        return assets if manifest.nil?

        assets = manifest.nil? ? [] : retrieve_assets_from(manifest)
        assets << manifest.rel
      end

      ##
      # If the action assets is only a file, finder will also consider it a
      # manifest file.
      # If the action assets is a foler consisting several asset files, finder will
      # includes all the assets inside this folder. Among these files, a file named
      # index.[js|css] will be taken as manifest file.
      def retrieve_action_assets
        action_path = PathInfo.new("#{app_path.to_s}/#{controller}")
        single_action_path = PathInfo.new("#{action_path}/#{action}.#{asset_extension}")
        indexed_action_path = PathInfo.new("#{action_path}/#{action}/index.#{asset_extension}")

        # find files in the conventional directory
        manifest = nil
        indexed_action = false
        manifest = single_action_path if FileTest.exist?(single_action_path)
        manifest = indexed_action_path if (indexed_action = FileTest.exist?(indexed_action_path))

        # TODO add rspec example
        return assets if manifest.nil?

        assets = manifest.nil? ? [] : retrieve_assets_from(manifest)
        if indexed_action
          assets.concat(Dir["#{action_path}/#{action}/**/*.#{asset_extension}"].map { |ass| PathInfo.new(ass).rel })
        else 
          assets << manifest.rel
        end
      end

      # start point of parsing dependent assets
      def retrieve_assets_from(manifest)
        # TODO rspec examples for non-existed files
        return [] unless FileTest.exist?(manifest)
      
        assets = []
        directive = Directive.new(asset_type)

        Pathname.new(manifest).each_line do |line|
          # break if directive.ending_directive?(l) # TODO: add ending_directive support
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

      # asset.js
      # /:another_controller/asset.js
      # => 
      # /path/to/app/public/app/javascript/:controller/asset.js
      # /path/to/app/public/app/javascript/:another_controller/asset.js
      def retrieve_app_asset(required_asset)
        required_asset = PathInfo.new(required_asset)

        dir = "#{app_path}/#{required_asset.match(/^\//) ? '' : "#{controller}/"}"
        asset = "#{required_asset}#{required_asset.with_ext? ? '' : ".#{asset_extension}"}"
        PathInfo.new(dir + asset)
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
      # todo BUG => can't retrieve assets with slash-asterisk(/*= xxx */) directive.
      # todo add specs for testing required folders without index
      def meta_retrieve(manifest_path, manifest)
        single_file_lib = PathInfo.new("#{manifest_path}/#{manifest}")

        manifest_dir = "#{manifest_path}/#{manifest}"
        indexing_lib = PathInfo.new("#{manifest_dir}/index")
        all_assets_in_manifest_dir = []

        real_manifest = nil
        if FileTest.exist?(single_file_lib)
          real_manifest = single_file_lib
          # TODO refactor => add for a hotfix loading required folders without index
          
          all_assets_in_manifest_dir = [real_manifest.rel]
        else FileTest.exist?(indexing_lib)
          real_manifest = indexing_lib
          
          all_assets_in_manifest_dir = Dir["#{manifest_dir}/**/*.#{asset_extension}"].map { |file| PathInfo.new(file).rel }
        end

        # TODO add specs for dependent assets sequence
        retrieve_assets_from(real_manifest).flatten
                                      .concat(all_assets_in_manifest_dir)
                                      .uniq
      end

      def root
        APP_ROOT
      end

      # TODO add tests
      def app_path
        "#{root}app/#{assets_path}"
      end
    
      # TODO add tests
      def lib_path
        "#{root}lib/#{assets_path}"
      end
    
      # TODO add tests
      def vendor_path
        "#{root}vendor/#{assets_path}"
      end
    end
  end
end
