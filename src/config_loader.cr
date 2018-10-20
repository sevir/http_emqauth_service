require "yaml"

class ConfigLoader
    @config: YAML::Any
    @path: String
    @auth: YAML::Any | Nil
    @rules: YAML::Any | Nil

    def initialize(@path = "./config.yml")
        @config = YAML.parse("---")
        @auth = nil
        @rules = nil
    end

    def load
        begin
            @config = File.open(@path) do |file|
                YAML.parse(file)
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