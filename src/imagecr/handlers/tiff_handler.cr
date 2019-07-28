module Imagecr
  module Handlers
    # Parses width and height from a Tiff image.
    class TiffHandler < Handler
      @pos : Int32 = 0

      # :nodoc:
      class Tag
        property! endianess

        @endianess : IO::ByteFormat?

        def initialize(@id : UInt16, @type : UInt16, @count : UInt32)
        end

        def id
          @id.to_i32
        end

        def read(io)
          value = read_impl(io)
          io.skip(4 - byte_size.not_nil!)
          value
        end

        def skip(io)
          io.skip(4)
        end

        private def byte_size
          case @type
          when 1
            (8 * @count) / 8
          when 2
            raise "no idea"
          when 3
            (16 * @count) / 8
          when 4
            (32 * @count) / 8
          when 5
            (64 * @count) / 8
          when 6, 7
            (8 * @count) / 8
          when 8
            (16 * @count) / 8
          when 9
            (32 * @count) / 8
          when 10
            (64 * @count) / 8
          when 11
            (32 * @count) / 8
          when 12
            (64 * @count) / 8
          end
        end

        private def read_impl(io)
          case @type
          when 3
            io.read_bytes(UInt16, endianess)
          when 4
            io.read_bytes(UInt32, endianess)
          end
        end
      end

      TIF_HEADERS = [
        UInt8.slice(0x49, 0x49),
        UInt8.slice(0x4D, 0x4D),
      ]

      @width : Int32 | Nil = nil
      @height : Int32 | Nil = nil
      @offset : Int32 = 0

      def parse_image
        io.skip(1)
        @pos = 4

        offset = handle_eof { io.read_bytes(UInt32, endianess) }
        @pos += 4

        if offset
          handle_eof do
            io.skip(offset - @pos)
            @pos += (offset - @pos)
          end

          tag_count = handle_eof { io.read_bytes(UInt16, endianess) }
          @pos += 2

          if tag_count
            tag_count.times do
              tag_id = handle_eof { io.read_bytes(UInt16, endianess) }
              data_type = handle_eof { io.read_bytes(UInt16, endianess) }
              data_count = handle_eof { io.read_bytes(UInt32, endianess) }
              @pos += 12

              if tag_id && data_count && data_type
                tag = Tag.new(tag_id, data_type, data_count)
                tag.endianess = endianess

                case tag.id
                when 256
                  width = tag.read(io)
                  case width
                  when .is_a?(UInt16)
                    @width = width.as(UInt16).to_i32
                  when .is_a?(UInt32)
                    @width = width.as(UInt32).to_i32
                  else
                    raise SizeNotFound.new if @options.raise_on_exception
                  end
                  @pos += 4
                when 257
                  height = tag.read(io)
                  case height
                  when .is_a?(UInt16)
                    @height = height.as(UInt16).to_i32
                  when .is_a?(UInt32)
                    @height = height.as(UInt32).to_i32
                  else
                    raise SizeNotFound.new if @options.raise_on_exception
                  end
                  @pos += 4
                else
                  tag.skip(io)
                  @pos += 4
                end
              end
            end

            if @width && @height
              return Image.new(@width.not_nil!, @height.not_nil!, "tiff")
            else
              offset = handle_eof { io.read_bytes(UInt32, endianess) }
              if offset
                return nil if offset == 0
                io.skip(offset - @pos)
                @pos += (offset - @pos)
              end
            end
          end
        end
        nil
      end

      def verify_remaining_header
        true
      end

      # :nodoc:
      private def endianess
        if header_bytes.not_nil![0, 2] == TIF_HEADERS.first
          IO::ByteFormat::LittleEndian
        else
          IO::ByteFormat::BigEndian
        end
      end
    end
  end
end
