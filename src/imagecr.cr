require "./imagecr/handler"
require "./imagecr/engine"
require "./imagecr/*"
require "uri"

module Imagecr
  class SizeNotFound < Exception
  end

  class UnknownImageType < Exception
  end

  class Options
    getter raise_on_exception, timeout
    def initialize(@raise_on_exception = false, @timeout = 2)
    end
  end

  # Open an image from a string. It can be a local path or remote path.
  def self.open(path : String, options = Options.new)
    engine = Engine.new(options)

    engine.open(URI.parse(path)) do |io|
      engine.parse(io)
    end
  end

  # Open an image from an `IO` object
  def self.open(io : IO, options = Options.new)
    engine = Engine.new(options)
    engine.parse(io)
  end

  def self.size(path : String, options = Options.new)
    open(path, options).try &. size
  end

  def self.size(io : IO, options = Options.new)
    open(io, options).try &.size
  end

  def self.type(path : String, options = Options.new)
    open(path, options).try &.type
  end

  def self.type(io : IO, options = Options.new)
    open(io, options).try &.type
  end
end
