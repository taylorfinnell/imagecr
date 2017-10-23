module Imagecr
  # :nodoc:
  module AbstractOpenStrategy
    abstract def open(uri, &block : IO -> _)
  end
end
