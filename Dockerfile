# Docker nif checker service

# Compile binary
FROM alpine:edge as compiler
# libraries:
# * musl-dev  =  libc dev libraries
# * curl-dev  =  we use web services so we need curl
#RUN apk add --update crystal=0.26.1-r0 musl-dev curl-dev yaml-dev
RUN apk add --update crystal=0.26.1-r0 musl-dev curl-dev yaml-dev
WORKDIR /app
ADD . /app
RUN cd /app && shards install && crystal -v && crystal build --release src/http_emqauth_service.cr

# Copy the binary and build the image
FROM alpine:edge
#RUN apk add --update pcre gc libevent libgcc musl libcurl
RUN apk add --update pcre gc libevent libgcc musl libcurl yaml
WORKDIR /app
COPY --from=compiler /app/http_emqauth_service /app
COPY ./config.yml /app
WORKDIR /app
ENTRYPOINT [ "/app/http_emqauth_service"]