module ViewAssets
  class Directive
    attr_reader :asset_type
    def initialize(asset_type)
      raise ConfigurationError.new('asset type should be "js" or "css"') unless %w(css js).include?(asset_type)
      @asset_type = asset_type
    end
    
    # return root folder and all the path params that have been split
    def parse(primitive_params)
      asset_root = ''
      path_params = []
      if vendor_directive =~ primitive_params
        asset_root = 'vendor'
        path_params = primitive_params.match(vendor_directive)[:path_params]
      elsif lib_directive =~ primitive_params
        asset_root = 'lib'
        path_params = primitive_params.match(lib_directive)[:path_params]
      elsif app_directive =~ primitive_params
        asset_root = 'app'
        path_params = primitive_params.match(app_directive)[:path_params]
      else
        raise UnknownDirectiveError.new
      end
      [asset_root, path_params.strip.split(/,\s?/)]
    end
    
    # def all_directives
    #   /#{tree_directive}|#{file_directive}/
    # end
    
    def vendor_directive
      @vendor_directive ||= generate_formula 'require_vendor'
    end
    
    def lib_directive
      @lib_directive ||= generate_formula 'require_lib'
    end

    def app_directive
      @app_directive ||= generate_formula
    end
    
    private
      ##
      # for javascript
      #   double-slash syntax => "//= require_vendor xxx"
      #   space-asterisk syntax => " *= require_vendor xxx"
      #   slash-asterisk syntax => "/*= require_vendor xxx */"
      # 
      # for stylesheets
      #   space-asterisk syntax => " *= require_vendor xxx"
      #   slash-asterisk syntax => "/*= require_vendor xxx */"
      # 
      # todo refactor => use reasonable and effective regular expression
      def generate_formula(requiring_type = 'require')
        if javascript? asset_type
          %r{
              ^//=\s#{requiring_type}\s(?<path_params>.*)$  # double-slash syntax
            |
              ^\s\*=\s#{requiring_type}\s(?<path_params>.*)$  # space-asterisk syntax
            |
              ^/\*=\s#{requiring_type}\s(?<path_params>.*)\s\*/$  # slash-asterisk syntax
          }x
        else
          %r{
              ^\s\*=\s#{requiring_type}\s(?<path_params>.*)$  # space-asterisk syntax
            |
              ^/\*=\s#{requiring_type}\s(?<path_params>.*)*\s\*/$  # slash-asterisk syntax
          }x
        end
      end
      
      def javascript? type
        %w(js javascript javascripts).include? type
      end
  end
end