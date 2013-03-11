module ViewAssets
  class Railtie < Rails::Railtie
    initializer "view_assets' initialzer" do
      # ViewAssets::ENV = Rails.env
      # ViewAssets::APP_ROOT = Rails.public_path
    end

    rake_tasks do
      require 'tasks/basic'
    end
  end
end