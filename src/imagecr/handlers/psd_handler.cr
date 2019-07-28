module Imagecr
  module Handlers
    class PsdHandler < Handler
      PSD_HEADER = UInt8.slice(56, 66, 80, 83)

      def parse_image
        handle_eof { io.skip(10) }

        height = handle_eof { io.read_bytes(Int32, IO::ByteFormat::BigEndian) }
        width = handle_eof { io.read_bytes(Int32, IO::ByteFormat::BigEndian) }

        Image.new(width, height, "psd") if width && height
      end

      def verify_remaining_header
        io.read_byte == PSD_HEADER.last
      end
    end
  end
end
