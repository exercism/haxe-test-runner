FROM haxe:4.2-alpine

RUN apk add --no-cache bash

COPY . /opt/test-runner
WORKDIR /opt/test-runner
RUN yes | haxelib install all
RUN haxe build.hxml
 
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
