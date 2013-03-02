module ViewAssets
  module Finder
    # TODO: add rspec examples
    # TODO: use JsAssetInfo module
    class JsFinder < Finder
      def assets_path
        # 'assets/javascripts'
        JS_PATH
      end
    
      def asset_extension
        JS_EXTENSION
      end
    
      def asset_type
        JS_TYPE
      end
    
      def tag(js_src)
        %(<script src="#{js_src}" type="text/javascript"></script>)
      end
    end
  end
end
