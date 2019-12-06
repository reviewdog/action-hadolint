FROM alpine:3.10

RUN apk add --update --no-cache git
RUN wget -q https://github.com/hadolint/hadolint/releases/download/v1.17.3/hadolint-Linux-x86_64 -O /bin/hadolint \
    && chmod +x /bin/hadolint

COPY entrypoint.sh /entrypoint.sh
COPY bin/reviewdog /bin/reviewdog

ENTRYPOINT ["/entrypoint.sh"]
