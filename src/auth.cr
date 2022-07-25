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

    def authorize( username : String , clientid : String, method : String , topic : String, ipaddress : String) : Bool
        # TODO: Check rules with clientid param
        if !@rules.nil?
            rules_not_nil : Array(YAML::Any) = @rules.as(Array(YAML::Any))

            rules_not_nil.each do |rule|
                if rule["user"] == username && check_method(rule["method"].to_s, method)
                    rule["topics"].as_a.each do |rule_topic|
                        parsed_rule = parse_rule( rule_topic.to_s, username, clientid, ipaddress)
                        if parsed_rule == topic || regexp_rule(parsed_rule) =~ topic
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

    private def check_method(rule_method : String, request_method : String)
      actions = { "publish" => 2, "subscribe" => 1 }

      begin
        request_method_int = request_method.to_i
      rescue
        request_method_int = actions[request_method]
      end

      case rule_method
      when "pubsub"
          true
      else
          (rule_method == "pub" && request_method_int == 2) || (rule_method == "sub" && request_method_int == 1)
      end
    end

    private def parse_rule(topic : String, username : String, clientid : String, ipaddress : String) : String
        topic.gsub /%[uci]/ do |variable|
            case variable
            when "%c"
                clientid
            when "%u"
                username
            when "%i"
                ipaddress
            end
        end
    end

    private def regexp_rule(rule_topic : String) : Regex
        regexp_rule = rule_topic.gsub /[\+#]/ do |variable|
            case variable
            when "+"
                "[^\s/]+"
            when "#"
                ".*"
            end
        end

        # Ignored exception when the rule is not a valid regex
        Regex.new(regexp_rule)
    end
end
