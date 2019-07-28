require "../../spec_helper"

module Imagecr::Handlers
  describe BmpHandler do
    describe "parse" do
      it "can parse OS/2 bmp" do
        handler = BmpHandler.new(
          bytes_io(
            1, 1, 1,     # bmp size, 1 byte already has been read
            1, 1, 1, 1,  # reserved
            1, 1, 1, 1,  # offset
            12, 0, 0, 0, # header size for os/2
            10, 0,       # w
            10, 0,       # h
          )
        )

        handler.parse.should eq(Image.new(10, 10, "bmp"))
      end

      it "can parse windows bmp" do
        handler = BmpHandler.new(
          bytes_io(
            1, 1, 1,     # bmp size, 1 byte already has been read
            1, 1, 1, 1,  # reserved
            1, 1, 1, 1,  # offset
            40, 0, 0, 0, # header size for windows
            10, 0, 0, 0, # w
            10, 0, 0, 0  # h
          )
        )

        handler.parse.should eq(Image.new(10, 10, "bmp"))
      end

      it "is nil on invalid bmp" do
        handler = BmpHandler.new(
          bytes_io(
            1, 1, 1
          )
        )

        handler.parse.should be_nil
      end

      it "is nil if can't read os/2 w" do
        handler = BmpHandler.new(
          bytes_io(
            1, 1, 1,     # bmp size, 1 byte already has been read
            1, 1, 1, 1,  # reserved
            1, 1, 1, 1,  # offset
            12, 0, 0, 0, # header size for os/2
          )
        )

        handler.parse.should be_nil
      end

      it "is nil if can't read os/2 h" do
        handler = BmpHandler.new(
          bytes_io(
            1, 1, 1,     # bmp size, 1 byte already has been read
            1, 1, 1, 1,  # reserved
            1, 1, 1, 1,  # offset
            12, 0, 0, 0, # header size for os/2
            10, 0,       # w
          )
        )

        handler.parse.should be_nil
      end

      it "is nil if cant read windows w" do
        handler = BmpHandler.new(
          bytes_io(
            1, 1, 1,     # bmp size, 1 byte already has been read
            1, 1, 1, 1,  # reserved
            1, 1, 1, 1,  # offset
            40, 0, 0, 0, # header size for windows
          )
        )

        handler.parse.should be_nil
      end

      it "is nil if cant read windows w" do
        handler = BmpHandler.new(
          bytes_io(
            1, 1, 1,     # bmp size, 1 byte already has been read
            1, 1, 1, 1,  # reserved
            1, 1, 1, 1,  # offset
            40, 0, 0, 0, # header size for windows
            1, 0, 0, 0,
          )
        )

        handler.parse.should be_nil
      end

      it "is nil if invalid header size" do
        handler = BmpHandler.new(
          bytes_io(
            1, 1, 1,    # bmp size, 1 byte already has been read
            1, 1, 1, 1, # reserved
            1, 1, 1, 1, # offset
            1, 0, 0, 0, # header size for windows
            1, 0, 0, 0,
            1, 0, 0, 0,
          )
        )

        handler.parse.should be_nil
      end

      describe "on Option#raise_on_exception" do
        it "raises if missing width" do
          handler = BmpHandler.new(
            bytes_io(
              1, 1, 1,     # bmp size, 1 byte already has been read
              1, 1, 1, 1,  # reserved
              1, 1, 1, 1,  # offset
              12, 0, 0, 0, # header size for os/2
            ),
            Options.new(raise_on_exception: true)
          )

          expect_raises Imagecr::SizeNotFound do
            handler.parse
          end
        end

        it "raises if missing height" do
          handler = BmpHandler.new(
            bytes_io(
              1, 1, 1,     # bmp size, 1 byte already has been read
              1, 1, 1, 1,  # reserved
              1, 1, 1, 1,  # offset
              12, 0, 0, 0, # header size for os/2
              10, 0        # w
            ),
            Options.new(raise_on_exception: true)
          )

          expect_raises Imagecr::SizeNotFound do
            handler.parse
          end
        end
      end
    end
  end
end
