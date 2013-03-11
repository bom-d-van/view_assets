module ViewAssets
  module Finder
    class JsFinder < Finder
      def assets_path
        # 'assets/javascripts'
        JS_PATH
      end

      def asset_extension
        JS_EXT
      end

      def asset_type
        JS_TYPE
      end

      def tag(src)
        ViewAssets.tag(:js, src)
      end
    end
  end
end
