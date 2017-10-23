module Imagecr
  abstract class Handler
    # First few bytes of the image.
    getter header_bytes

    # The image IO, excluding header bytes
    getter io

    def initialize(@io : IO, @header_bytes : Bytes? = nil)
    end

    # Parse the image, returning an `Image` if one is found.
    def parse
      return nil unless verify_remaining_header
      parse_image
    end

    # Returns nil if EOF is hit
    private def handle_eof(&block)
      begin
        yield
      rescue IO::EOFError
        return nil
      end
    end

    # Verifiy the rest of the header, that was not checked by `Engine`
    abstract def verify_remaining_header

    # Actual parsing implementation
    abstract def parse_image
  end
end

require "./handlers/bmp_handler"
require "./handlers/gif_handler"
require "./handlers/png_handler"
require "./handlers/psd_handler"
require "./handlers/tiff_handler"
require "./handlers/unknown_handler"
