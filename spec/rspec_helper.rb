$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib/view_assets')

class Rails
  def self.public_path; end

  class Railtie
    class << self
      def initializer(*args)
      end

      def rake_tasks(*args)
      end
    end
  end
end

require 'view_assets'
include ViewAssets
