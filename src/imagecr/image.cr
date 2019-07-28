module Imagecr
  # A model representing an image with a width, height and type.
  class Image
    # The pixel width of the image.
    getter width

    # The pixel height of the image.
    getter height

    # The type of the image.
    getter type

    def initialize(@width : Int32, @height : Int32, @type : String)
    end

    def size
      [@width, @height]
    end

    def_equals @width, @height, @type
  end
end
