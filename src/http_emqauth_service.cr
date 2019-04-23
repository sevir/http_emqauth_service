require "./config_loader"
require "./auth"
require "./web_ui"
require "kemal"

module HttpEmqauthService
  VERSION = "0.3.0"

  ENV["SPEC"] ||= "false"
  ENV["DEBUG"] ||= "false"
  ENV["PORT"] ||= "3000"
  ENV["WEBUI"] ||= "false"

  RUNNING_SPEC = ENV["SPEC"] == "true"

  begin
    config = ConfigLoader.new
    
    config.load
    auth = Auth.new(config.getAuth, config.getRules)

    puts "Configuration loaded" unless RUNNING_SPEC

    webui = WebUi.new


    # Running webserver
    get "/auth" do |env|
      clientid = env.params.query["clientid"].as(String)
      username = env.params.query["username"].as(String)
      password = env.params.query["password"].as(String)

      env.response.content_type = "application/json"

      if auth.authenticate(username, password)
        env.response.status_code = 200
        {"status": "ok"}.to_json
      else
        env.response.status_code = 401
        {"status": "unauthorized"}.to_json
      end
    end

    # Superuser is disabled
    get "/superuser" do |env|
      clientid = env.params.query["clientid"].as(String)
      username = env.params.query["username"].as(String)
      ipaddress = env.params.query["ipaddress"].as(String)

      env.response.status_code = 401
      {"status": "unauthorized"}.to_json
    end

    get "/acl" do |env|
      clientid = env.params.query["clientid"].as(String)
      username = env.params.query["username"].as(String)
      ipaddress = env.params.query["ipaddress"].as(String)
      topic = env.params.query["topic"].as(String)
      method = env.params.query["access"].as(String)

      env.response.content_type = "application/json"

      if auth.authorize(username, clientid, method, topic, ipaddress)
        env.response.status_code = 200
        {"status": "ok"}.to_json
      else
        env.response.status_code = 401
        {"status": "unauthorized"}.to_json
      end
    end

    get "/reload" do |env|
      begin
        config.load
        auth = Auth.new(config.getAuth, config.getRules)

        puts "Configuration reloaded" if ENV["DEBUG"] == "true"
        env.response.status_code = 200
        {"status": "ok"}.to_json
      rescue exception
        env.response.status_code = 500
        {"status": exception.message}.to_json
      end
    end
    
    if ENV["WEBUI"] == "true"
      get "/" do |env|
        webui.index(config.getYaml)
      end

      post "/saveconfig" do |env|
        begin
          yaml_str = env.params.body["yaml"].as(String)
  
          config.setYaml yaml_str
          config.load
  
          puts "New config saved" if ENV["DEBUG"] == "true"
  
          env.response.status_code = 200
          {"status": "ok"}.to_json
        rescue exception
          env.response.status_code = 500
          {"status": exception.message}.to_json
        end
      end
    end
    

    unless RUNNING_SPEC
      # Listening server
      puts "Listening 0.0.0.0:#{ENV["PORT"]}"
      Kemal.config.logging = false unless ENV["DEBUG"] == "true"
      Kemal.run { |cfg| cfg.server.not_nil!.listen("0.0.0.0", ENV["PORT"].to_i, reuse_port: true) }
    end
  rescue exception
    puts exception
    exit(1)
  end
end
