module ViewAssets
  module Manager
    class Modifier
      def update(index, new_index)
        type = retrieve_type(index)
        validate_index = map[type].key?(index)

        unless validate_index
          map.each_value do |manifests|
            validate_index = manifests.select do |manifest, indexes|
                               indexes.any? do |map_index|
                                 map_index.match(index)
                               end
                             end

            break if validate_index
          end
        end

        raise Error.new("#{index} is not exist.") unless validate_index

        update_index(index, new_index)
        update_requirements(index, new_index)
      end

      def retrieve_type(index)
        case
        when /^vendor\/.+$/.match(index)
          :vendor
        when /^lib\/.+$/.match(index)
          :lib
        when /^app\/.+$/.match(index)
          :app
        end
      end

      def update_index(index, new_index)
        path_to_index = PathInfo.new(index).abs
        new_path_to_index = PathInfo.new(new_index).abs

        if FileTest.exists?(path_to_index)
          FileUtils.mv(path_to_index, new_path_to_index)
        elsif FileTest.exists?("#{path_to_index}.#{ext}")
          FileUtils.mv("#{path_to_index}.#{ext}", "#{new_path_to_index}.#{ext}")
        else
          raise Error.new("Manifest #{index} doesn't exist.")
        end
      end

      def update_requirements(index, new_index)
        map.each_value do |type|
          type.each do |manifest, requirements|
            if requirements.any? { |requirement| requirement == index }
              requirements[requirements.index(index)] = new_index

              modify(manifest, generate_requirements_block(manifest, requirements))
            end
          end
        end
      end

      def generate_requirements_block(manifest, requirements)
        if retrieve_type(manifest) == :app
          # Remove 'app/:asset_path/application' or
          #        'app/:asset_path/application.:ext'
          requirements.delete("app/#{asset_path}/application")
          requirements.delete("app/#{asset_path}/application.#{ext}")

          # Remove 'app/:asset_path/controller/controller' or
          #        'app/:asset_path/controller/controller.ext'
          if manifest.count('/') > 2
            controller_asset = manifest.gsub(
                                 /(?<path>.+\/.+\/(?<controller>.+)\/).+/,
                                 '\k<path>\k<controller>'
                               )

            requirements.delete("#{controller_asset}")
            requirements.delete("#{controller_asset}.#{ext}")
          end
        end

        requirements.delete("#{manifest}.#{ext}")
        requirements.reject! { |req| req.match(manifest + '/') }

        requirements.each_with_object(["/**"]) do |requirement, block|
          directive, prefix = case retrieve_type(requirement)
                              when :vendor
                                [' *= require_vendor ', "vendor/#{asset_path}/"]
                              when :lib
                                [' *= require_lib ', "lib/#{asset_path}/"]
                              when :app
                                [' *= require ', "app/#{asset_path}"]
                              end

          block.push("#{directive}#{requirement.gsub(prefix, "")}")
        end.push(' */').join("\n")
      end

      def remove(index)

      end

      def modify(path, new_requirement_block)
        path = PathInfo.new(path).abs
        manifest = if FileTest.exists?("#{path}.#{ext}")
                     "#{path}.#{ext}"
                   elsif FileTest.exists?("#{path}/index.#{ext}")
                     "#{path}/index.#{ext}"
                   else
                     raise Error.new("Can't Load #{path.rel}")
                   end

        start_of_requirement_block = false
        end_of_requirement_block = false
        asset_content = ''

        Pathname.new(manifest).each_line do |line|
          legal_directive = analyize(*directive.parse(line))

          start_of_requirement_block = true if legal_directive && !start_of_requirement_block
          end_of_requirement_block = true if !legal_directive && start_of_requirement_block && !end_of_requirement_block

          if !start_of_requirement_block || end_of_requirement_block
            asset_content << line
          end
        end

        File.open(manifest, 'w') do |file|
          file << new_requirement_block
          file << asset_content
        end
      end

      def analyize(type, asset)
        return type != '' || asset != []
      end

      def map
        @map_value
      end

      def update_map
        @map_value = @map.draw
      end
    end

    class JsModifier < Modifier
      def initialize
        @map = ::ViewAssets::Manager::JsMap.new
        @map_value = @map.draw
      end

      DIRECTIVE = ::ViewAssets::Finder::Directive.new(JS_TYPE)
      def directive
        DIRECTIVE
      end

      def ext
        JS_EXT
      end

      def asset_path
        ::ViewAssets::JS_PATH
      end
    end

    class CssModifier < Modifier
      def initialize
        @map = ::ViewAssets::Manager::CssMap.new
        @map_value = @map.draw
      end

      DIRECTIVE = ::ViewAssets::Finder::Directive.new(CSS_TYPE)
      def directive
        DIRECTIVE
      end

      def ext
        CSS_EXT
      end

      def asset_path
        ::ViewAssets::CSS_PATH
      end
    end
  end
end