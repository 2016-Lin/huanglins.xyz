# hugo
FROM golang:1.14-alpine

WORKDIR /src

RUN apk add --no-cache git

ARG HUGO_SOURCE_VERSION=v0.65.3

RUN git clone -b $HUGO_SOURCE_VERSION https://github.com/gohugoio/hugo.git --single-branch

WORKDIR /src/hugo

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build  -o /usr/local/bin/

FROM caddy/caddy:1.0.4

WORKDIR /var/www/

CMD ["hugo","--help","&&","git","version"]
