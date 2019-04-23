require "yaml"

class ConfigLoader
    @yaml_str: String
    @config: YAML::Any
    @path: String
    @auth: YAML::Any | Nil
    @rules: YAML::Any | Nil

    def initialize(@path = "./config.yml")
        @config = YAML.parse "---"
        @auth = nil
        @rules = nil
        @yaml_str = ""

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
                @yaml_str = File.read(@path)
            else
                @yaml_str = ENV["CONFIG_YAML"]
            end
            
            @config = YAML.parse @yaml_str
            
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

    def getYaml
        @yaml_str
    end

    def setYaml(yml_str : String)
        @yaml_str = yml_str

        if ENV["CONFIG_YAML"].empty?
            File.write @path, yml_str
        else
            ENV["CONFIG_YAML"] = @yaml_str
        end
    end
end