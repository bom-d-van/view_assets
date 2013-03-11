module ViewAssets
  module Finder
    class CssFinder < Finder
      def assets_path
        CSS_PATH
      end

      def asset_extension
        CSS_EXT
      end

      def asset_type
        CSS_TYPE
      end

      def tag(href)
        ViewAssets.tag(:css, href)
      end
    end
  end
end
