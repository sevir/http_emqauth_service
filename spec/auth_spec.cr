require "./spec_helper"
require "../src/auth"
require "../src/config_loader"

def with_env_yaml
    ENV["CONFIG_YAML"] = <<-CONFIG
        ---
        auth:
          test1: env1

        rules:
          - user: test1
            method: publish
            topics: 
            - topic1/%u/final
        CONFIG

    yield

    ENV["CONFIG_YAML"] = ""
end

describe "Auth" do
    conf = ConfigLoader.new
    conf.load

    it "Authenticate works" do
        auth = Auth.new(conf.getAuth, conf.getRules)
        auth.authenticate("test1", "pass1").should be_true
    end

    it "Authorize works" do
        auth = Auth.new(conf.getAuth, conf.getRules)
        auth.authorize("test1", "test1_cliid", "publish", "topic1").should be_true
    end

    it "Authorize with variables works" do
        with_env_yaml do
            conf_with_variables = ConfigLoader.new
            conf_with_variables.load

            auth = Auth.new(conf_with_variables.getAuth, conf_with_variables.getRules)
            auth.authorize("test1", "test1_cliid", "publish", "topic1/test1/final").should be_true
        end
    end
end