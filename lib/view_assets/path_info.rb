module ViewAssets
  class PathInfo < String
    def initialize(path)
      replace path
    end
    
    def abs?
      !!match(/^#{root}/)
    end
    
    # alter path string
    #   'lib.js'
    # => 
    #   '/path/to/app/public/:type/file.js'
    def abs
      return self if abs?
      @absolutized = true
    
      "#{root}/#{with_ext? ? self : "#{self}.#{ext}" }"
    end
    
    def abs!
      replace abs
    end
    
    def with_ext?
      !!match(/\.(#{JS_EXT}|#{CSS_EXT})$/)
    end

    # alter path string
    #   '/path/to/app/:dir/assets/:asset_type/file.js'
    #  => 
    #   'file.js'
    def rel
      return self unless abs?
      @absolutized = false
      
      gsub(/^#{root}\//, '')
    end
    
    def rel!
      replace rel
    end
    
    def root
      "#{APP_ROOT}"
    end
  end
end
