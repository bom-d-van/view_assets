module ViewAssets
  # TODO add rspec examples
  class StyleSheetAssets < AssetsFinder
    def assets_path
      # 'assets/javascripts'
      'stylesheets'
    end
    
    def asset_extension
      'css'
    end
    
    def asset_type
      'stylesheet'
    end
    
    def tag(css_href)
      "<link href='#{css_href}' media='screen' rel='stylesheet' />"
    end
  end
end