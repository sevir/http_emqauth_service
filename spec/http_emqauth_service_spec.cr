require "./spec_helper"
require "../src/config_loader"

describe HttpEmqauthService do
  config = ConfigLoader.new("./config.yml")
  config.load

  it "authentication works" do
    config.authenticate("test1", "pass1").should eq(true)
  end

  it "authorization works" do
    config.authorize("test1", "publish", "topic1").should eq(true)
  end
end
