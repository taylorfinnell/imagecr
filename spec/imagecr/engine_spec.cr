require "../spec_helper"
require "secure_random"

module Imagecr
  describe Engine do
    it "has a HEADER_LEN" do
      Engine::HEADER_LEN.should eq(3)
    end

    describe "open" do
      it "can open local files" do
        path = "/tmp/#{SecureRandom.uuid}"
        File.write(path, "test")

        engine = Engine.new
        engine.open(URI.parse(path)) do |io|
          io.should be_a(IO)
          io.gets_to_end.should eq("test")
        end
      end

      it "can open http files" do
        engine = Engine.new
        engine.open(URI.parse("https://google.com")) do |io|
          io.should be_a(IO)
        end
      end
    end
  end
end
