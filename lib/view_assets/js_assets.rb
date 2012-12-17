module ViewAssets
  class JavascriptAssets < AssetsFinder
    def assets_path
      "#{root_path}/javascripts"
    end
    
    def asset_extension
      'js'
    end
    
    def asset_type
      'javascript'
    end
    
    def tag(js_src)
      "<script src='#{js_src}'></script>"
    end
  end
end