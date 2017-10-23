require "http/client"

module Imagecr
  # :nodoc:
  class RemoteFileOpenStrategy
    include AbstractOpenStrategy

    def open(uri, &block : IO -> _)
      HTTP::Client.get(uri.to_s) do |resp|
        yield resp.body_io
      end
    end
  end
end
