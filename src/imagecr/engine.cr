require "./open_strategy/abstract"
require "./open_strategy/*"

require "uri"

module Imagecr
  class Engine
    # :nodoc:
    HEADER_LEN = 3

    # Open a file using the given strategy to determine which type of image it
    # is.
    def open(uri : URI, &block)
      strat = if ["https", "http"].includes?(uri.scheme)
                RemoteFileOpenStrategy.new
              else
                if uri.scheme == "file" || File.exists?(uri.to_s)
                  LocalFileOpenStrategy.new
                else
                  nil
                end
              end

      return nil if strat.nil?

      strat.open(uri) do |io|
        yield io
      end
    end

    # Parse a given IO to determine type of image
    def parse(io)
      header_bytes = Bytes.new(HEADER_LEN)
      io.read(header_bytes)

      handler = case header_bytes
                when Handlers::GifHandler::GIF_HEADER
                  Handlers::GifHandler.new(io)
                when Handlers::PngHandler::PNG_HEADER
                  Handlers::PngHandler.new(io)
                else
                  if Handlers::BmpHandler::BITMAP_HEADERS.includes?(header_bytes[0, 2])
                    Handlers::BmpHandler.new(io)
                  elsif Handlers::PsdHandler::PSD_HEADER[0, 3] == header_bytes
                    Handlers::PsdHandler.new(io)
                  elsif Handlers::TiffHandler::TIF_HEADERS.includes?(header_bytes[0, 2])
                    Handlers::TiffHandler.new(io, header_bytes)
                  else
                    Handlers::UnknownHandler.new(io)
                  end
                end

      handler.parse
    end
  end
end
