module ViewAssets
  module Packager
    def compile
      require 'yui-compressor'
    end
  
    # class Compressor
    #   def compress
    #   
    #   end
    # end
    #   
    # class JsCompressor < Compressor
    #   def type
    #     JS_TYPE
    #   end
    # end
    #   
    # class CssCompressor < Compressor
    #   def type
    #     CSS_TYPE
    #   end
    # end
    
    module_function :compile
  end
end
