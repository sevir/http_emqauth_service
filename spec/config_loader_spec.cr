require "./spec_helper"

def with_env_yaml
    ENV["CONFIG_YAML"] = <<-CONFIG
        ---
        auth:
          test1: env1

        rules:
          - user: test1
            method: publish
            topics: 
            - topic1
        CONFIG

    yield

    ENV["CONFIG_YAML"] = ""
end

def with_env_path
    ENV["CONFIG_PATH"] = "./dont.yml"

    yield

    ENV["CONFIG_PATH"] = ""
end

describe "ConfigLoader" do
    
    it "Load existing config works!" do
        conf = ConfigLoader.new
        conf.load
        
        conf.getAuth.should be_truthy
        conf.getRules.should be_truthy
    end

    it "Load not existing config doesn't work" do
        conf_error = ConfigLoader.new "./dont.yml"
        puts "Warning error is ok"
        conf_error.load
        
        conf_error.getAuth.should be_nil
        conf_error.getRules.should be_nil
    end

    it "Load not existing config across env environment path" do
        with_env_path do
            conf_error = ConfigLoader.new "./dont.yml"
            puts "Warning error is ok"
            conf_error.load
            
            conf_error.getAuth.should be_nil
            conf_error.getRules.should be_nil
        end        
    end

    it "Load YML from env YAML" do
        with_env_yaml do
            conf = ConfigLoader.new
            conf.load
            
            conf.getAuth.should be_truthy
            conf.getRules.should be_truthy
        end        
    end
end