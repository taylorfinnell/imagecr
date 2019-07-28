ENV["ENV"] = "test"

require "spec"
require "../src/imagecr"

def data_dir
  File.expand_path(File.join(File.dirname(__FILE__), "data"))
end

def bytes(*bytes)
  arr = bytes.map(&.to_u8)
  slice = Slice(UInt8).new(bytes.size)
  arr.each_with_index { |byte, idx| slice[idx] = byte }
  slice
end

def bytes_io(*b)
  IO::Memory.new(bytes(*b))
end
