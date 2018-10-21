require "./spec_helper"
require "../src/auth"
require "../src/config_loader"

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

end