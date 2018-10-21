# http_emqauth_service

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
  # Possible methods "publish", "subscribe"
    method: publish
  # Topics allow variables %c for client id and $u for username
    topics: 
      - topic1/%u
      - topic2
```

## Development

Install the required shards with:

```bash
shards install
```

Create the specs for testing your changes.

Tested and build with Crystal 0.26.1

## Contributing

1. Fork it (<https://github.com/your-github-user/http_emqauth_service/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [SeViR](https://github.com/sevir) José Fco. Rives - creator, maintainer
