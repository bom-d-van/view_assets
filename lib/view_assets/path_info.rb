module ViewAssets
  class PathInfo < String
    def ==(pi)
      pi = PathInfo.new(pi) unless pi.kind_of?(PathInfo)

      self.rel.to_s == pi.rel.to_s
    end

    def initialize(path)
      replace path
    end

    def abs?
      !match(/^#{root}/).nil?
    end

    # alter path string
    #   'lib.js'
    # =>
    #   '/path/to/app/public/:type/file.js'
    def abs
      return self if abs?

      # PathInfo.new("#{root}/#{with_ext? ? self : "#{self}.#{ext}" }")
      PathInfo.new("#{root}/#{self}")
    end

    def abs!
      replace abs
    end

    def with_ext?
      !!match(/\.(#{JS_EXT}|#{CSS_EXT})$/)
    end

    def basename
      PathInfo.new(with_ext? ? chomp(File.extname(self)) : self)
    end

    # alter path string
    #   '/path/to/app/:dir/assets/:asset_type/file.js'
    #  =>
    #   'file.js'
    def rel
      return self unless abs?

      PathInfo.new(gsub(/^#{root}\//, ''))
    end

    def rel!
      replace rel
      self
    end

    def root
      "#{Rails.public_path}"
    end

    def lib?
      rel.match(/^lib\/(#{JS_PATH}|#{CSS_PATH})/)
    end

    def vendor?
      rel.match(/^vendor\/(#{JS_PATH}|#{CSS_PATH})/)
    end

    def app?
      rel.match(/^app\/(#{JS_PATH}|#{CSS_PATH})/)
    end

    # PathInfo.new('lib/javascripts/file.js').depth # => 0
    # PathInfo.new('app/javascripts/controller/action/file.js').depth # => 2
    # PathInfo.new('/path/to/my/app/public/lib/javascripts/file.js').depth # => 0
    def depth
      rel.count("/") - 2
    end
  end
end