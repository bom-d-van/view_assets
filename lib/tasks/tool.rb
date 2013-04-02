namespace :va do
  namespace :tool do
    require 'view_assets/manager/manager'

    desc "Change Manifest Name"
    task :mv, [:type, :original, :new_name] do |t, args|
      case args.type
      when 'js'
        ViewAssets::Manager::JsModifier.new.update(args.original, args.new_name, { :verbal =>  true })
      when 'css'
        ViewAssets::Manager::CssModifier.new.update(args.original, args.new_name, { :verbal =>  true })
      else
        puts "Unrecognized Type: #{args.type}"
      end
    end

    desc "Remove Manifest"
    task :rm, [:type, :manifest] do |t, args|
      case args.type
      when 'js'
        ViewAssets::Manager::JsModifier.new.remove(args.manifest, { :verbal =>  true })
      when 'css'
        ViewAssets::Manager::CssModifier.new.remove(args.manifest, { :verbal =>  true })
      else
        puts "Unrecognized Type: #{args.type}"
      end
    end
  end
end