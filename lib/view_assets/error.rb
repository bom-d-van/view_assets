module ViewAssets
  class ConfigurationError < StandardError; end
  # class UnimplementedError < StandardError; end
  class UnknownDirectiveError < StandardError; end
  class FileNotFound < StandardError; end
end
