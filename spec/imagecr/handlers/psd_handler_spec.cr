require "../../spec_helper"

module Imagecr::Handlers
  describe PsdHandler do
    it "returns nil if can't verify header" do
      handler = PsdHandler.new(
        bytes_io(1)
      )

      handler.parse.should be_nil
    end

    it "fails if invalid psd" do
      handler = PsdHandler.new(
        bytes_io(83, 1)
      )

      handler.parse.should be_nil
    end

    it "fails if can't read width" do
      handler = PsdHandler.new(
        bytes_io(83,
          1, 1,             # version
          0, 0, 0, 0, 0, 0, # reserved
          1, 1,             # chans
          # missing with
        )
      )

      handler.parse.should be_nil
    end

    it "fails if can't read height" do
      handler = PsdHandler.new(
        bytes_io(83,
          1, 1,             # version
          0, 0, 0, 0, 0, 0, # reserved
          1, 1,             # chans
          0, 0, 0, 10       # missing height

        )
      )

      handler.parse.should be_nil
    end

    it "can read width and height" do
      handler = PsdHandler.new(
        bytes_io(83,
          1, 1,             # version
          0, 0, 0, 0, 0, 0, # reserved
          1, 1,             # chans
          0, 0, 0, 10,
          0, 0, 0, 10
        )
      )

      handler.parse.should eq(Image.new(10, 10, "psd"))
    end
  end
end
