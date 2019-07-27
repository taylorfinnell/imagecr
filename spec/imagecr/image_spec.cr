require "../spec_helper"

module Imagecr
  describe Image do
    it "has a width" do
      image = Image.new(1, 1, "test")
      image.width.should eq(1)
    end

    it "has a type" do
      image = Image.new(1, 1, "test")
      image.type.should eq("test")
    end

    it "has a height" do
      image = Image.new(1, 1, "test")
      image.height.should eq(1)
    end
  end
end
