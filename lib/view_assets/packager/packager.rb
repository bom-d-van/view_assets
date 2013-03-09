module ViewAssets
  module Packager
    require 'yui/compressor'
    require 'openssl'
    require 'pathname'
    require 'yaml'

    class Packager
      def package
        # preparing envs
        FileUtils.mkdir_p("#{root}/assets/#{CSS_PATH}")
        FileUtils.mkdir_p("#{root}/assets/#{JS_PATH}")

        # packaging
        manifest = {}
        actions_map.retrieve.each do |controller, actions|
          actions.map do |action|
            sources = finder.retrieve(controller, action)
            content = concatenate(sources)
            compressed_content = compress(content)
            file_name = "#{controller}_#{action}-#{fingerprint(compressed_content)}.#{asset_ext}"

            manifest["/assets/#{controller}_#{action}.#{asset_ext}"] = "/assets/#{file_name}"

            File.open("#{root}/assets/#{asset_path}/#{file_name}", 'w') do |file|
              file << compressed_content
            end
          end
        end

        File.open("#{root}/assets/#{asset_path}/manifest.yml", 'w') do |file|
          YAML.dump(manifest, file)
        end
      end

      def root
        APP_ROOT
      end

      private

      def concatenate(sources)
        sources.inject("") do |content, source|
          content += File.open(source.abs, 'r').read
          # content += "\n;\n"
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

      FINDER = JsFinder.new
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

      CSS_FINDER = CssFinder.new
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
