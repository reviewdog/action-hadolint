FROM alpine:3.10

RUN wget -q https://github.com/hadolint/hadolint/releases/download/v1.17.3/hadolint-Linux-x86_64 \
    && chmod +x hadolint-Linux-x86_64

COPY entrypoint.sh /entrypoint.sh
COPY bin/reviewdog /bin/reviewdog

ENTRYPOINT ["/entrypoint.sh"]
