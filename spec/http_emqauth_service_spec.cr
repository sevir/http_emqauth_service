require "./spec_helper"
require "../src/config_loader"

describe HttpEmqauthService do
  config = ConfigLoader.new("./config.yml")
  config.load
  auth = Auth.new(config.getAuth, config.getRules)

  it "authentication works" do
    auth.authenticate("test1", "pass1").should eq(true)
  end

  it "authorization works" do
    auth.authorize("test1", "clientid", "publish", "topic1").should eq(true)
  end
end
