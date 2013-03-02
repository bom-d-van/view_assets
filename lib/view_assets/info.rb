module ViewAssets
  module JsAssetInfo
    JS_TYPE = 'javascript'
    JS_EXTENSION = 'js'
    JS_PATH = 'javascripts'
    
    def type
      JS_TYPE
    end
    
    def extension
      JS_EXTENSION
    end
    
    def path
      JS_PATH
    end
  end
  
  module CssAssetInfo
    CSS_TYPE = 'css'
    CSS_EXTENSION = 'css'
    CSS_PATH = 'stylesheets'
    
    def type
      Css_type
    end
    
    def extension
      CSS_EXTENSION
    end
    
    def path
      CSS_PATH
    end
  end
end
