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

    describe "from http" do
      it "works for http" do
        image = Imagecr.open("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png");

        image.should eq(Imagecr::Image.new(544, 184, "png"))
      end

      it "gives nil on 404" do
        image = Imagecr.open("https://www.google.com/images/branding/googlelogo/asdasd.png");

        image.should eq(nil)
      end
    end
  end
end
