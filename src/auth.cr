require "yaml"

alias YAML_Nil = YAML::Any | Nil
alias YAML_Hash = Hash(YAML::Any, YAML::Any)

class Auth
    @auth : Hash(YAML::Any, YAML::Any) | Nil
    @rules : Array(YAML::Any) | Nil

    def initialize(basic_auth : YAML_Nil, rules : YAML_Nil )
        @auth = basic_auth.as_h? unless basic_auth.nil?
        @rules = rules.as_a? unless rules.nil?
    end

    def authenticate( username : String , password : String) : Bool
        user : YAML::Any::Type = username
        
        if !@auth.nil?
            auth_not_nil : YAML_Hash = @auth.as(YAML_Hash)
            auth_not_nil.has_key?(user) && auth_not_nil[ user ] == password
        else
            false
        end
    end

    def authorize( username : String , clientid : String, method : String , topic : String) : Bool
        # TODO: Check rules with clientid param
        if !@rules.nil?
            rules_not_nil : Array(YAML::Any) = @rules.as(Array(YAML::Any))

            rules_not_nil.each do |rule|
                if rule["user"] == username && rule["method"] == method
                    rule["topics"].as_a.each do |rule_topic|
                        if parse_rule( rule_topic.to_s, username, clientid) == topic
                            return true
                        end
                    end
                end
            end
            
            false
        else
            false
        end
    end

    private def parse_rule(topic : String, username : String, clientid : String) : String
        topic.gsub /%[uc]/ do |variable|
            case variable
            when "%c"
                clientid
            when "%u"
                username
            end
        end
    end
end