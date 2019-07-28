require "./imagecr/handler"
require "./imagecr/engine"
require "./imagecr/*"
require "uri"

module Imagecr
  # Open an image from a string. It can be a local path or remote path.
  def self.open(path : String)
    engine = Engine.new

    engine.open(URI.parse(path)) do |io|
      engine.parse(io)
    end
  end

  # Open an image from an `IO` object
  def self.open(io : IO)
    engine = Engine.new
    engine.parse(io)
  end

  def self.size(path : String)
    open(path).try &. size
  end

  def self.size(io : IO)
    open(io).try &.size
  end

  def self.type(path : String)
    open(path).try &.type
  end

  def self.type(io : IO)
    open(io).try &.type
  end
end
