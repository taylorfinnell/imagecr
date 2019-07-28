module Imagecr
  module Handlers
    # Parses width and height properties out a Bitmap image.
    class BmpHandler < Handler
      BITMAP_HEADERS = [
        UInt8.slice(66, 77),
        UInt8.slice(66, 65),
        UInt8.slice(67, 73),
        UInt8.slice(67, 80),
        UInt8.slice(73, 67),
        UInt8.slice(80, 84),
      ]

      def parse_image
        handle_eof { io.skip(11) }

        header = handle_eof { io.read_bytes(Int32) }

        case header
        when 12
          width = handle_eof { io.read_bytes(UInt16) }
          height = handle_eof { io.read_bytes(UInt16) }

          Image.new(width.to_i32, height.to_i32, "bmp") if width && height
        when 40
          width = handle_eof { io.read_bytes(Int32, IO::ByteFormat::LittleEndian) }
          height = handle_eof { io.read_bytes(Int32, IO::ByteFormat::LittleEndian) }

          # ImageHeight is expressed in pixels. The absolute value is necessary because ImageHeight can be negative
          Image.new(width.to_i32, height.to_i32.abs, "bmp") if width && height
        end
      end

      def verify_remaining_header
        true
      end
    end
  end
end
