module Imagecr
  module Handlers
    # Parses width and height properties out a PSD image.
    class PngHandler < Handler
      # :nodoc:
      PNG_HEADER = UInt8.slice(137, 80, 78)

      # :nodoc:
      REMAINING_HEADER_SLICE = UInt8.slice(71, 13, 10, 26, 10) # G ...

      # :nodoc:
      IHDR_SLICE = UInt8.slice(73, 72, 68, 82) # IHDR

      def parse_image
        return nil unless ihdr?(io)

        width = handle_eof do
          io.read_bytes(Int32, IO::ByteFormat::BigEndian)
        end

        height = handle_eof do
          io.read_bytes(Int32, IO::ByteFormat::BigEndian)
        end

        if width.nil? || height.nil?
          raise SizeNotFound.new if @options.raise_on_exception
        else
          Image.new(width, height, "png") if width && height
        end
      end

      def verify_remaining_header
        bytes = Bytes.new(REMAINING_HEADER_SLICE.size)
        io.read(bytes)
        bytes == REMAINING_HEADER_SLICE
      end

      # :nodoc:
      private def ihdr?(io)
        bytes = Bytes.new(IHDR_SLICE.size)

        ihdr_length = handle_eof do
          io.read_bytes(Int32, IO::ByteFormat::BigEndian)
        end

        if ihdr_length
          io.read(bytes)
          bytes == IHDR_SLICE
        else
          nil
        end
      end
    end
  end
end
