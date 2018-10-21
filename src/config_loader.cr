require "yaml"

class ConfigLoader
    @config: YAML::Any
    @path: String
    @auth: YAML::Any | Nil
    @rules: YAML::Any | Nil

    def initialize(@path = "./config.yml")
        @config = YAML.parse "---"
        @auth = nil
        @rules = nil

        # ENV variables
        ENV["CONFIG_YAML"] ||= ""
        ENV["CONFIG_PATH"] ||= ""
        @path = if ENV["CONFIG_PATH"].empty?
                @path
            else
                 ENV["CONFIG_PATH"]
            end
    end

    def load
        begin
            if ENV["CONFIG_YAML"].empty?
                @config = YAML.parse File.read(@path)
            else
                @config = YAML.parse ENV["CONFIG_YAML"]
            end

            begin
                @auth = @config["auth"]
                @rules = @config["rules"]
            rescue
            end
        rescue exception
            puts exception
        end
    end
    
    def getAuth
        @auth
    end

    def getRules
        @rules
    end

end