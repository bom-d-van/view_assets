module ViewAssets
  class Directive
    attr_reader :asset_type
    def initialize(asset_type)
      raise ConfigurationError.new('asset type should be "js" or "css"') unless %w(css js).include?(asset_type)
      @asset_type = asset_type
    end
    
    # TODO realize this method
    # remember to take different syntax into consideration
    def ending_directive?(primitive_params)
      # primitive_params.match
    end
    
    # TODO add docs
    def legal_directive?(primitive_params)
      [vendor_directive, lib_directive, app_directive].any? { |d| d =~ primitive_params }
    end
    
    # return root folder and all the path params that have been split
    # TODO this method bellow need refactor
    def parse(primitive_params)
      asset_root = ''
      path_param_str = ''
      path_params = []
      unknown_directive = false
      
      # TODO make sure path_param_str will return nil for non-matched result and array for matched result
      # rememer to write tests for this section of codes
      if vendor_directive =~ primitive_params
        asset_root = 'vendor'
        path_param_str = primitive_params.match(vendor_directive)[:path_params]
      elsif lib_directive =~ primitive_params
        asset_root = 'lib'
        path_param_str = primitive_params.match(lib_directive)[:path_params]
      elsif app_directive =~ primitive_params
        asset_root = 'app'
        path_param_str = primitive_params.match(app_directive)[:path_params]
      else
        # TODO remove UnknownDirectiveError or try to find another way to get thing done
        # raise UnknownDirectiveError.new "'#{primitive_params}' is not in legal directive format"
        unknown_directive = true
      end
      
      # TODO refactor codes bellow after the above paragraph was refactored
      would_be_path_params = path_param_str.strip.split(/,\s?/)
      # would_be_path_params = [would_be_path_params] if would_be_path_params.kind_of?(String)
      path_params = would_be_path_params unless would_be_path_params.empty?
      
      # unknown_directive ? [nil, nil] : [asset_root, path_params.strip.split(/,\s?/)]
      [asset_root, path_params]
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
      # TODO refactor: use reasonable and effective regular expression
      # TODO use "require_app" as app asset directive and make "require" as a relative directive
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