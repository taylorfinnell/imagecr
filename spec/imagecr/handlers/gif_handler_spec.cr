require "../../spec_helper"

module Imagecr::Handlers
  describe GifHandler do
    describe "parse" do
      it "returns nil if invalid header" do
        handler = GifHandler.new(bytes_io(1, 1, 1, 1, 1, 1, 1, 1))

        handler.parse.should be_nil
      end

      it "is nil if w cant be read" do
        handler = GifHandler.new(
          bytes_io(
            56, 55, 97,
          )
        )

        handler.parse.should be_nil
      end

      it "is nil if w cant be read" do
        handler = GifHandler.new(
          bytes_io(
            56, 55, 97,
            10, 0, # w
          )
        )

        handler.parse.should be_nil
      end

      it "is nil if rest of header can't be verified" do
        handler = GifHandler.new(
          IO::Memory.new
        )

        handler.parse.should be_nil
      end

      it "can support GIF87a" do
        handler = GifHandler.new(
          bytes_io(
            56, 55, 97,
            10, 0, # w
            10, 0  # h
          )
        )

        handler.parse.should eq(Image.new(10, 10, "gif"))
      end

      it "can support GIF89a" do
        handler = GifHandler.new(
          bytes_io(
            56, 57, 97,
            10, 0, # w
            10, 0  # h
          ))

        handler.parse.should eq(Image.new(10, 10, "gif"))
      end
    end
  end
end
