module TTFunk
  class Table
    class Cmap

      module Format14
        attr_reader :language
        attr_reader :code_map

        def self.encode(charmap)
          subtable = [14, 10, 0].pack('nNN')
          { :charmap => {}, :subtable => subtable, :max_glyph_id => 0 }
        end

        def [](code)
          @code_map[code] || 0
        end

        def supported?
          true
        end

        private
          def parse_cmap!
            raise 'Unicode Variation Sequences require platform ID 0 and encoding ID 5' unless @platform_id == 0 && @encoding_id == 5
            @code_map = {}
            skip_cmap!
         end

          def skip_cmap!
            length, varcount = read(8, 'NN')
            read(length - 8, 'C*')
          end

          # WIP

          def parse_header!
            length, var_count = read(8, 'NN')
            (1..var_count).each do
              var_selector =  read_uint24
              default_offset, non_default_offset = read(8, 'NN')
            end
          end

          def parse_default_uvs!
            unicode_values = []
            range_count = read(4, 'N')
            (1..range_count).each do
              start  = read_uint24
              length = read(1, 'C')
              unicode_values += (start..start+length).to_a
            end
            return unicode_values
          end

          def parse_non_default_uvs!
            mappings = {}
            mapping_count = read(4, 'N')
            (1..mapping_count).each do
              unicode = read_uint24
              glyph   = read(2, 'n')
              mappings[unicode] = glyph
            end
            return mappings
          end

          def read_uint24
            c1, c2, c3 = read(3, 'CCC')
            c1 + 256 * c2 + 65536 * c3
          end
      end

    end
  end
end
