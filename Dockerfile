FROM hadolint/hadolint

COPY entrypoint.sh /entrypoint.sh
COPY bin/reviewdog /bin/reviewdog

CMD ["/entrypoint.sh"]
