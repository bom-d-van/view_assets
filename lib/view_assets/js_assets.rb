module ViewAssets
  # TODO add rspec examples
  class JavascriptAssets < AssetsFinder
    def assets_path
      # 'assets/javascripts'
      Javascript_Path
    end
    
    def asset_extension
      Javascript_Extension
    end
    
    def asset_type
      Javascript_Type
    end
    
    def tag(js_src)
      %(<script src="#{js_src}" type="text/javascript"></script>)
    end
  end
end