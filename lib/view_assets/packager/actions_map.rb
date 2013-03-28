module ViewAssets
  module Packager
    class ActionsMap
      # @return => { :controller1 => [:action1, :action2, ..], ..}
      def retrieve
        action_path.children.select(&:directory?).each_with_object({}) do |controller, action_map|
          all_children = controller.children.map do |action|
            action.basename.to_s.chomp(action.extname)
          end

          controller_name = controller.basename.to_s
          action_map[controller.basename.to_s] = all_children.select { |action| action.to_s != controller_name }
        end
      end

      private

      def action_path
        puts PathInfo.new("#{APP_FOLDER}/#{asset_path}").abs
        Pathname.new(PathInfo.new("#{APP_FOLDER}/#{asset_path}").abs)
      end
    end

    class JsActionsMap < ActionsMap
      def asset_path
        JS_PATH
      end
    end

    class CssActionsMap < ActionsMap
      def asset_path
        CSS_PATH
      end
    end
  end
end