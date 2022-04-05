FROM haxe:4.2-alpine

COPY . /opt/test-runner
WORKDIR /opt/test-runner
RUN yes | haxelib install all
RUN haxe build.hxml
RUN apk add --no-cache bash
 
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
