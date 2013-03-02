module ViewAssets
  module Finder
    # TODO add rspec examples
    class StyleSheetAssets < Finder
      def assets_path
        # 'assets/javascripts'
        CSS_PATH
      end
    
      def asset_extension
        CSS_TYPE
      end
    
      def asset_type
        CSS_TYPE
      end
    
      def tag(css_href)
        "<link href='#{css_href}' media='screen' rel='stylesheet' />"
      end
    end
  end
end
