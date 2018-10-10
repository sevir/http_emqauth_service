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

      spawn do
        if config.authenticate(username, password)
          env.response.status_code = 200
          {"status": "ok"}.to_json
        else
          env.response.status_code = 401
          {"status": "unauthorized"}.to_json
        end
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

      spawn do
        if config.authorize(username, method, topic)
          env.response.status_code = 200
          {"status": "ok"}.to_json
        else
          env.response.status_code = 401
          {"status": "unauthorized"}.to_json
        end
      end
    end

    get "/reload" do |env|
      spawn do
        config.load
        puts "Configuration loaded"
  
        env.response.status_code = 200
        {"status": "ok"}.to_json
      end
    end

    Kemal.config.logging = false
    Kemal.run { |cfg| cfg.server.not_nil!.listen("0.0.0.0",3000, reuse_port: true) }

  rescue exception
    puts exception
    exit(1)
  end

  
end
