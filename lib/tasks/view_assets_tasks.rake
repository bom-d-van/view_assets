# desc "Explaining what the task does"
# task :view_assets do
#   # Task goes here
# end

namespace :view_assets do
  desc "Init view_assets framework"
  task :init do
    public_path = "#{ Rails.root }/public"
    %w(vendor lib app).map { |d| %w(javascripts stylesheets).map { |t| "#{public_path}/#{d}/#{t}" } }.flatten.each do |dir|
      FileUtils.mkdir dir
      puts "\t\033[1;32mCreate\033[0m #{dir}"
      if dir.include?('app')
        fn_extension = dir.include?('javascripts') ? 'js' : 'css'
        FileUtils.touch "Create #{dir}/application.#{fn_extension}"
        puts "\t\033[1;32mCreate\033[0m #{dir}/application.#{fn_extension}"
      end
    end
  end
end