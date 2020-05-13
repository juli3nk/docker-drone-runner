FROM drone/drone-runner-docker:1

RUN apk --update --no-cache add bash

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
