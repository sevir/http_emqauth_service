require "./spec_helper"

describe "ConfigLoader" do
    it "Load existing config works!" do
        conf = ConfigLoader.new

        conf.load
        conf.getAuth.should be_truthy
        conf.getRules.should be_truthy
    end

    it "Load not existing config doesn't work" do
        conf = ConfigLoader.new "./dont.yml"

        conf.load
        conf.getAuth.should be_nil
        conf.getRules.should be_nil
    end
end