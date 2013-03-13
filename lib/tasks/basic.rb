# desc "Explaining what the task does"
# task :view_assets do
#   # Task goes here
# end

namespace :va do
  desc "Init view_assets framework(create app, lib and vendor folders in /public folder)"
  task :init do
    require 'term/ansicolor'
    include Term::ANSIColor

    public_path = Rails.public_path

    puts "init asset folders in /public: "
    %w(vendor lib app).map { |d| %w(javascripts stylesheets).map { |t| "#{public_path}/#{d}/#{t}" } }.flatten.each do |dir|
      FileUtils.mkdir_p dir
      puts "\t#{green(bold("Create"))} #{dir.gsub(public_path, '')}"
      if dir.include?('app')
        fn_extension = dir.include?('javascripts') ? 'js' : 'css'
        FileUtils.touch "#{dir}/application.#{fn_extension}"
        puts "\t#{green(bold("Create"))}[0m #{dir.gsub(public_path, '')}/application.#{fn_extension}"
      end
    end
  end

  desc "Compress assets for deployment(Must be executed before running rails app on production mode)"
  task :compress do
    require 'view_assets/packager/core'
    require 'term/ansicolor'
    include Term::ANSIColor

    puts green(bold("packaging js assets"))
    ViewAssets::Packager::JsPackager.new.package

    puts green(bold("packaging css assets"))
    ViewAssets::Packager::CssPackager.new.package
  end

  desc "Check assets to know whether it is eligible"
  task :validate, [:controller, :action] do |t, args|
    args.with_defaults(:controller => '', :action => '')

    require 'view_assets/packager/core'
    require 'term/ansicolor'
    include Term::ANSIColor

    if args.controller.empty? || args.action.empty?
      puts red(bold("Please specify controller and action correctly: rake va:validate[:controller,:action]"))
    end

    controller = args.controller
    action = args.action

    puts green(bold("Packaging Js Assets"))
    js_manifest = ViewAssets::Packager::JsPackager.new.package({ controller => action.split('/') }, { :verbal =>  true, :compress => false, :manifest => false })

    puts green(bold("Packaging Css Assets"))
    css_manifest = ViewAssets::Packager::CssPackager.new.package({ controller => action.split('/') }, { :verbal =>  true, :compress => false, :manifest => false })

    puts "-------"

    unless js_manifest.empty?
      js_manifest.each_value do |asset|
        puts "#{green("Checking:")} #{asset}"
        `java -jar #{File.expand_path("../yuicompressor-2.4.4.jar", File.dirname(__FILE__))} #{Rails.public_path}#{asset}`
      end
    end

    unless css_manifest.empty?
      css_manifest.each_value do |asset|
        puts "#{green("Checking:")} #{asset}"
        `java -jar #{File.expand_path("../yuicompressor-2.4.4.jar", File.dirname(__FILE__))} #{Rails.public_path}#{asset}`
      end
    end
  end
end