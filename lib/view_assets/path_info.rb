module ViewAssets
  class Path < String
    attr_reader :dir
    
    def initialize(path, dir = 'app')
      replace path
      
      @dir = dir
      
      @absolutized = absolutize?
    end
    
    def absolutize?
      !!match(/^#{APP_ROOT}/)
    end
    
    # alter path string
    #   'lib.js'
    # to
    #   '/path/to/app/:dir/assets/:asset_type/file.js'
    def absolutize
      return self if @absolutized
      @absolutized = true
    
      "#{root}/#{contain_extension? ? self : "#{self}.#{extension}" }"
    end
    
    def absolutize!
      replace absolutize
    end
    
    def contain_extension?
      !!match(/\.#{ extension }$/)
    end

    # alter path string from
    #   '/path/to/app/:dir/assets/:asset_type/file.js'
    # to
    #   'file.js'
    def unabsolutize
      return self unless @absolutized
      @absolutized = false
      
      gsub(/^#{ root }\//, '')
    end
    
    def unabsolutize!
      replace unabsolutize
    end
    
    private
    
    def root
      "#{APP_ROOT}/#{asset_root}"
    end
    
    def asset_root
      "#{dir}/assets/#{path}"
    end
  end
  
  class JsPath < Path
    include JsAssetInfo
  end
  
  class CssPath < Path
    include CssAssetInfo
  end
end
