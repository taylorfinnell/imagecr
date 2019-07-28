require "../../spec_helper"

module Imagecr::Handlers
  describe PngHandler do
    describe "parse" do
      it "returns nil if invalid header" do
        handler = PngHandler.new(
          bytes_io(
            26, 10,        # rest of sig
            0, 0, 0, 13,   # ihdr len
            73, 72, 68, 82 # invalid ihdr
          ))

        handler.parse.should be_nil
      end

      it "returns nil if invalid ihdr" do
        handler = PngHandler.new(
          bytes_io(
            26, 10,        # rest of sig
            0, 0, 0, 13,   # ihdr len
            73, 72, 68, 81 # invalid ihdr
          ))

        handler.parse.should be_nil
      end

      it "returns nil if width cant be read" do
        handler = PngHandler.new(
          bytes_io(
            71, 13, 10, 26, 10, # rest of sig
            0, 0, 0, 13,        # ihdr len
            73, 72, 68, 82,     # ihdr
          ))

        handler.parse.should be_nil
      end

      it "returns nil if h cant be read" do
        handler = PngHandler.new(
          bytes_io(
            71, 13, 10, 26, 10, # rest of sig
            0, 0, 0, 13,        # ihdr len
            73, 72, 68, 82,     # ihdr
            0, 0, 0, 10,        # w
          ))

        handler.parse.should be_nil
      end

      it "returns nil if rest of header cant be verified" do
        handler = PngHandler.new(
          bytes_io(
            71, 13
          ))

        handler.parse.should be_nil
      end

      it "returns nil if ihdr length cant be read" do
        handler = PngHandler.new(
          bytes_io(
            71, 13, 10, 26, 10, # rest of sig
            0, 0
          ))

        handler.parse.should be_nil
      end

      it "returns an image if valid png" do
        handler = PngHandler.new(
          bytes_io(
            71, 13, 10, 26, 10, # rest of sig
            0, 0, 0, 13,        # ihdr len
            73, 72, 68, 82,     # ihdr
            0, 0, 0, 10,        # w
            0, 0, 0, 10,        # h
            0, 0, 0, 0          # rest of ihdr
          ))

        handler.parse.should eq(Image.new(10, 10, "png"))
      end

      describe "on Options#raise_on_exception" do
        it "raises on missing width" do
          handler = PngHandler.new(
            bytes_io(
              71, 13, 10, 26, 10, # rest of sig
              0, 0, 0, 13,        # ihdr len
              73, 72, 68, 82,     # ihdr
            ), Options.new(raise_on_exception: true))

          expect_raises SizeNotFound do
            handler.parse
          end
        end

        it "raises on missing height" do
          handler = PngHandler.new(
            bytes_io(
              71, 13, 10, 26, 10, # rest of sig
              0, 0, 0, 13,        # ihdr len
              73, 72, 68, 82,     # ihdr
              0, 0, 0, 10,        # w
            ), Options.new(raise_on_exception: true))

          expect_raises SizeNotFound do
            handler.parse
          end
        end
      end
    end
  end
end
