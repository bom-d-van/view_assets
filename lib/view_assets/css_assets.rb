module ViewAssets
  # TODO add rspec examples
  class StyleSheetAssets < AssetsFinder
    def assets_path
      # 'assets/javascripts'
      Css_Path
    end
    
    def asset_extension
      Css_Type
    end
    
    def asset_type
      Css_Type
    end
    
    def tag(css_href)
      "<link href='#{css_href}' media='screen' rel='stylesheet' />"
    end
  end
end
