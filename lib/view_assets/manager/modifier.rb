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

              modify(manifest, generate_requirements_block(requirements))
            end
          end
        end
      end

      def generate_requirements_block(requirements)
        requirements.each_with_object("") do |requirement, block|
          directive = case retrieve_type(requirement)
                      when :vendor
                        '//= require_vendor '
                      when :lib
                        '//= require_lib '
                      when :app
                        '//= require '
                      end

          block += "#{directive}#{requirement}\n"
        end
      end

      def remove(index)

      end

      def modify(asset, new_requirement_block)
        start_of_requirement_block = false
        end_of_requirement_block = false
        asset_content = ''

        Pathname.new(asset).each_line do |line|
          legal_directive = analyize(*directive.parse(line))

          start_of_requirement_block = true if legal_directive && !start_of_requirement_block
          end_of_requirement_block = true if !legal_directive && start_of_requirement_block && !end_of_requirement_block

          if !start_of_requirement_block || end_of_requirement_block
            asset_content << line
          end
        end

        File.open(asset, 'w') do |file|
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
    end

    class CssModifier < Modifier
      DIRECTIVE = ::ViewAssets::Finder::Directive.new(CSS_TYPE)
      def directive
        DIRECTIVE
      end
    end
  end
end