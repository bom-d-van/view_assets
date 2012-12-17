module ViewAssets
  class StyleSheetAssets < AssetsFinder
    def assets_path
      "#{root_path}/stylesheets"
    end
    
    def asset_extension
      'css'
    end
    
    def tag(css_href)
      "<link href='#{css_href}' media='screen' rel='stylesheet' />"
    end
  end
end
