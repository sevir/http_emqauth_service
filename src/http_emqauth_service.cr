require "./config_loader"

module HttpEmqauthService
  VERSION = "0.1.0"

  begin
    config = ConfigLoader.new
    config.load
  rescue exception
    puts exception
    exit(1)
  end

  
end
