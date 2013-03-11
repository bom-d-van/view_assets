module ViewAssets
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class UnknownDirectiveError < Error; end
  class FileNotFound < Error; end
end
