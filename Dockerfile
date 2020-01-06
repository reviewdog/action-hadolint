FROM alpine:3.10

ENV \
    HADOLINT_VERSION=1.17.3 \
    REVIEWDOG_VERSION=0.9.15

# hadolint ignore=DL3018
RUN apk add --no-cache git
RUN wget -q https://github.com/hadolint/hadolint/releases/download/v$HADOLINT_VERSION/hadolint-Linux-x86_64 -O /usr/local/bin/hadolint \
    && chmod +x /usr/local/bin/hadolint

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ v$REVIEWDOG_VERSION

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
