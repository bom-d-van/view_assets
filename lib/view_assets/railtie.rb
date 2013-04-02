module ViewAssets
  class Railtie < Rails::Railtie
    initializer "view_assets' initialzer" do
      require 'view_assets/action_view'
    end

    rake_tasks do
      require 'tasks/basic'
      require 'tasks/tool'
    end
  end
end