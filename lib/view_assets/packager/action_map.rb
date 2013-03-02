module ViewAssets
  class ActionMap
    include AssetPathKnowable
      
    def retrieve
      asset_path.children.select(&:directory?).each_with_object({}) do |controller, action_map|
        action_map[controller.basename.to_s] = controller.children.map do |action|
          action.basename.to_s.chomp(action.extname)
        end
      end
    end
    
    def parse_dependencies
      
    end
  end
    
  class JsActionMap < ActionMap
    include JsAssetInfo
      
    def asset_path
      app_path.join path
    end
    
    def finder
      JsAssets
    end
  end

  class CssActionMap < ActionMap
    include CssAssetInfo
      
    def asset_path
      app_path.join path
    end
  end
end