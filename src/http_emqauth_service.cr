require "./config_loader"
require "kemal"


module HttpEmqauthService
  VERSION = "0.1.0"

  begin
    config = ConfigLoader.new
    config.load

    puts "Configuration loaded"

    # Running webserver
    get "/auth" do |env|
      clientid = env.params.query["clientid"].as(String)
      username = env.params.query["username"].as(String)
      password = env.params.query["password"].as(String)

      env.response.content_type = "application/json"

      if config.authenticate(username, password)
        env.response.status_code = 200
        {"status": "ok"}.to_json
      else
        env.response.status_code = 401
        {"status": "unauthorized"}.to_json
      end
    end

    get "/super" do |env|
      clientid = env.params.query["clientid"].as(String)
      username = env.params.query["username"].as(String)
      ipaddress = env.params.query["ipaddress"].as(String)

      env.response.status_code = 401
      {"status": "unauthorized"}.to_json
    end

    get "/check" do |env|
      clientid = env.params.query["clientid"].as(String)
      username = env.params.query["username"].as(String)
      password = env.params.query["password"].as(String)
      ipaddress = env.params.query["ipaddress"].as(String)
      topic = env.params.query["topic"].as(String)
      method = env.params.query["method"].as(String)

      env.response.content_type = "application/json"

      if config.authorize(username, method, topic)
        env.response.status_code = 200
        {"status": "ok"}.to_json
      else
        env.response.status_code = 401
        {"status": "unauthorized"}.to_json
      end
    end

    get "/reload" do |env|
      config.load
      puts "Configuration loaded"

      env.response.status_code = 200
      {"status": "ok"}.to_json
    end


    Kemal.run

  rescue exception
    puts exception
    exit(1)
  end

  
end
