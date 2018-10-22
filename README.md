# HTTP EMQ Auth service

This service allow to emq MQTT server, a flexible configuration for authentication and authorization without restart the service.

The http auth service is build as binary program with Crystal Lang

## Installation

Download the last binary release or build from sources

## Usage

The service will be listing in the port 3000 by default. Run normally with

```bash
./http_emqauth_service
```

### Setting up with ENV variables

Define `CONFIG_PATH` for changing the path of the configuration file .yml

Define `CONFIG_YAML` for insert the configuration as string in the env environment

Define `PORT` if you want to change the default listen port 3000

Define `DEBUG` if you want see the debug info

### Running with config file

By default the program will load the file `config.yml`

### The structure of the config.yml

```yaml
---
auth:
  test1: pass1
  test2: pass2

rules:
  - user: test1
  # Possible methods "pub", "sub", "pubsub"
    method: pubsub
  # Topics allow variables %c for client id and $u for username
    topics: 
      - topic1/%u
      - topic2
```

## Building and deploy with Docker

* Build a Docker image from sources

```bash
docker build -t http_emqauth_service .
```

* Run the image mounting the config and setting up some env variables

```bash
docker run -p 127.0.0.1:3000:3000 \
-e "DEBUG=true" -e "CONFIG_PATH=config1.yml" \
--mount type=bind,source="$(pwd)"/config.yml,target=/app/config1.yml  \
http_emqauth_service
```

## Configure the plugin emqx_auth_http in EMQ for this service

File: `etc/emqx_auth_http.conf`

```
##--------------------------------------------------------------------
## Authentication request.
##
## Variables:
##  - %u: username
##  - %c: clientid
##  - %a: ipaddress
##  - %P: password
##
## Value: URL
auth.http.auth_req = http://127.0.0.1:3000/auth
auth.http.auth_req.method = get
## Value: Params
auth.http.auth_req.params = clientid=%c,username=%u,password=%P

##--------------------------------------------------------------------
## Superuser request.
##
## Variables:
##  - %u: username
##  - %c: clientid
##  - %a: ipaddress
##
## Value: URL
auth.http.super_req = http://127.0.0.1:3000/superuser
auth.http.super_req.method = get
## Value: Params
auth.http.super_req.params = clientid=%c,username=%u

##--------------------------------------------------------------------
## ACL request.
##
## Variables:
##  - %A: 1 | 2, 1 = sub, 2 = pub
##  - %u: username
##  - %c: clientid
##  - %a: ipaddress
##  - %t: topic
##
## Value: URL
auth.http.acl_req = http://127.0.0.1:3000/check
auth.http.acl_req.method = get
## Value: Params
auth.http.acl_req.params = method=%A,username=%u,clientid=%c,ipaddr=%a,topic=%t
```

## Development

Install the required shards with:

```bash
shards install
```

Create the specs for testing your changes.

Tested and build with Crystal 0.26.1

## Contributing

1. Fork it (<https://github.com/sevir/http_emqauth_service/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [SeViR](https://github.com/sevir) José Fco. Rives - creator, maintainer
