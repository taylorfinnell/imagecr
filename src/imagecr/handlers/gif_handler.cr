module Imagecr
  module Handlers
    # Parses width and height properties out a Gif image.
    class GifHandler < Handler
      # :nodoc:
      GIF_HEADER = UInt8.slice(71, 73, 70)

      # :nodoc:
      GIF87A_SLICE = UInt8.slice(56, 55, 97) # 87a

      # :nodoc:
      GIF89A_SLICE = UInt8.slice(56, 57, 97) # 89a

      def parse_image
        width = handle_eof do
          io.read_bytes(Int16)
        end

        height = handle_eof do
          io.read_bytes(Int16)
        end

        if width.nil? || height.nil?
          raise SizeNotFound.new if @options.raise_on_exception
        else
          Image.new(width.not_nil!.to_i32, height.not_nil!.to_i32, "gif")
        end
      end

      def verify_remaining_header
        bytes = Bytes.new(GIF89A_SLICE.size)
        io.read(bytes)
        bytes == GIF89A_SLICE || bytes == GIF87A_SLICE
      end
    end
  end
end
