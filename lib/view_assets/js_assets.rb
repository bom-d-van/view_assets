module ViewAssets
  # TODO add rspec examples
  class JsAssets < AssetsFinder
    def assets_path
      # 'assets/javascripts'
      Js_Path
    end
    
    def asset_extension
      Js_Extension
    end
    
    def asset_type
      Js_Type
    end
    
    def tag(js_src)
      %(<script src="#{js_src}" type="text/javascript"></script>)
    end
  end
end
