require "yaml"

class ConfigLoader
    @auth : Hash(YAML::Any, YAML::Any)
    @rules : Array(YAML::Any)

    def initialize
        @auth = Hash(YAML::Any, YAML::Any).new
        @rules = Array(YAML::Any).new
    end

    def load
        begin
            config = File.open("./config.yml") do |file|
                YAML.parse(file)
            end

            @auth = config["auth"].as_h
            @rules = config["rules"].as_a

        rescue exception
            raise exception
        end
    end

    def authenticate( username : String , password : String) : Bool
        user : YAML::Any::Type = username
        
        @auth.has_key?(user) && @auth[ user ] == password
    end

    def authorize( username : String , method : String , topic : String) : Bool
        @rules.each do |rule|
            if rule["user"] == username && rule["method"] == method
                rule["topics"].as_a.each do |rule_topic|
                    if rule_topic == topic
                        return true
                    end
                end
            end
        end

        false
    end
end