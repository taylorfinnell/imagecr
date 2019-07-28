require "kemal"

class Server
  public_folder File.expand_path("./spec/data")

  def self.run
    Kemal.run
  end
end

spawn do
  Server.run
end
