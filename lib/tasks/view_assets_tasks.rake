# desc "Explaining what the task does"
# task :view_assets do
#   # Task goes here
# end

namespace :view_assets do
  desc "Init view_assets framework"
  task :init do
    public_path = Rails.public_path
    %w(vendor lib app).map { |d| %w(javascripts stylesheets).map { |t| "#{public_path}/#{d}/#{t}" } }.flatten.each do |dir|
      FileUtils.mkdir_p dir
      puts "\t\033[1;32mCreate\033[0m #{dir.gsub(public_path, '')}"
      if dir.include?('app')
        fn_extension = dir.include?('javascripts') ? 'js' : 'css'
        FileUtils.touch "#{dir}/application.#{fn_extension}"
        puts "\t\033[1;32mCreate\033[0m #{dir.gsub(public_path, '')}/application.#{fn_extension}"
      end
    end
  end
end