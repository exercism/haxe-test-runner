FROM haxe:4.1-alpine

# RUN apk update && apk upgrade && \
#     apk add --no-cache bash git openssh && \
#     apk add wget git

COPY . /opt/test-runner
WORKDIR /opt/test-runner
RUN yes | haxelib install all
RUN haxe build.hxml

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]