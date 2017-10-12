FROM golang:1.9-alpine

EXPOSE 9110

RUN addgroup exporter \
 && adduser -S -G exporter exporter

COPY . /go/src/github.com/mesosphere/mesos_exporter

RUN apk --update add ca-certificates \
 && apk --update add --virtual build-deps git
RUN cd /go/src/github.com/mesosphere/mesos_exporter \
 && GOPATH=/go go get \
 && GOPATH=/go go build -o /bin/mesos-exporter \
 && apk del --purge build-deps \
 && rm -rf /go/bin /go/pkg /var/cache/apk/*

USER exporter

ENTRYPOINT [ "/bin/mesos-exporter" ]
