require "./spec_helper"

describe Imagecr do
  describe "open" do
    it "can detect pngs" do
      image = Imagecr.open("#{data_dir}/png.png")

      image.should eq(Imagecr::Image.new(10, 10, "png"))
    end

    it "can detect gifs" do
      image = Imagecr.open("#{data_dir}/gif.gif")

      image.should eq(Imagecr::Image.new(10, 10, "gif"))
    end

    it "can detect bmp" do
      image = Imagecr.open("#{data_dir}/bmp.bmp")

      image.should eq(Imagecr::Image.new(10, 10, "bmp"))
    end

    it "can detect psd" do
      image = Imagecr.open("#{data_dir}/psd.psd")

      image.should eq(Imagecr::Image.new(10, 10, "psd"))
    end

    it "can detect tiff" do
      image = Imagecr.open("#{data_dir}/tiff.tiff")

      image.should eq(Imagecr::Image.new(10, 10, "tiff"))
    end
  end
end
