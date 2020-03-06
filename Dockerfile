FROM alpine:3.9.5

RUN apk add --no-cache \
    git \
    ca-certificates

COPY caddy /usr/bin/caddy
COPY hugo /usr/local/bin/hugo

COPY ssl/ /etc/ssl/caddy/
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80
EXPOSE 433

CMD ["caddy","--config","/etc/caddy/Caddyfile"]