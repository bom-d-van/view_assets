module ViewAssets
  module Packager
    require 'yui/compressor'
    require 'openssl'
    require 'pathname'
    require 'yaml'

    class Packager
      # targets = { :controller => [:action1, :action2], ... }
      # options:
      #   :verbal => false
      def package(targets = {}, options = {})
        options = { :verbal => false, :compress => true, :manifest => true }.update(options)
        targets = actions_map.retrieve if targets.empty?

        # preparing envs
        FileUtils.mkdir_p("#{root}/assets/#{CSS_PATH}")
        FileUtils.mkdir_p("#{root}/assets/#{JS_PATH}")

        # packaging
        manifest = {}
        targets.each do |controller, actions|
          actions.map do |action|
            # retrieving asset sources
            sources = finder.retrieve(controller, action)
            if sources.empty?
              puts "Asset: #{controller}.#{action} not existed" if options[:verbal]
              next
            elsif options[:verbal]
              puts "Packaging: #{controller}.#{action}"
            end

            # package assets: concatenate | compress | fingerprint
            content = concatenate(sources)
            compressed_content = options[:compress] ? compress(content) : content
            file_name = "#{controller}_#{action}-#{fingerprint(compressed_content)}.#{asset_ext}"

            # save indices of packaged assets
            manifest["/assets/#{asset_path}/#{controller}_#{action}.#{asset_ext}"] = "/assets/#{asset_path}/#{file_name}"

            # save packaged assets
            File.open("#{root}/assets/#{asset_path}/#{file_name}", 'w') { |file| file << compressed_content }
          end
        end

        File.open("#{root}/assets/#{asset_path}/manifest.yml", 'w') { |file| YAML.dump(manifest, file) } if options[:manifest]

        return manifest
      end

      def root
        Rails.public_path
      end

      private

      def concatenate(sources)
        sources.inject("") do |content, source|
          content += File.open(source.abs, 'r').read
          content += (asset_ext == 'js' ? "\n;\n" : "")
        end
      end

      def compress(content)
        compressor.compress(content)
      end

      Digestor = OpenSSL::Digest::MD5.new
      def fingerprint(content)
        Digestor.hexdigest(content)
      end
    end

    class JsPackager < Packager
      def actions_map
        JsActionsMap.new
      end

      FINDER =  ViewAssets::Finder::JsFinder.new
      def finder
        FINDER
      end

      def asset_ext
        JS_EXT
      end

      COMPRESSOR = YUI::JavaScriptCompressor.new(:munge => true)
      def compressor
        COMPRESSOR
      end

      def asset_path
        JS_PATH
      end
    end

    class CssPackager < Packager
      def actions_map
        CssActionsMap.new
      end

      CSS_FINDER = ViewAssets::Finder::CssFinder.new
      def finder
        CSS_FINDER
      end

      def asset_ext
        CSS_EXT
      end

      COMPRESSOR = YUI::CssCompressor.new
      def compressor
        COMPRESSOR
      end

      def asset_path
        CSS_PATH
      end
    end
  end
end
