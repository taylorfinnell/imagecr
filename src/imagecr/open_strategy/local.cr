module Imagecr
  # :nodoc:
  class LocalFileOpenStrategy
    include AbstractOpenStrategy

    def open(uri, &block : IO -> _)
      File.open(uri.to_s, "r") do |file|
        yield file
      end
    end
  end
end
