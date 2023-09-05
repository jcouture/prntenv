FROM golang:1.20.7@sha256:37c7d8580e0616e96914a67291b9693fe038ab677eb9b5deb81e541b2322f20f AS build

WORKDIR /build
COPY . /build

RUN go mod download && go mod verify

ENV CGO_ENABLED=0

RUN go build -ldflags="-w -s" -v -x -o prntenv ./cmd/prntenv/ && \
  strip prntenv

FROM alpine:3.18.3@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a AS upx

RUN apk --no-cache add upx=4.0.2-r0

COPY --from=build /build/prntenv /prntenv

RUN upx -q -9 prntenv

FROM scratch

HEALTHCHECK NONE

COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

COPY --from=upx --chown=65534:0 /prntenv /prntenv

USER nobody

ENTRYPOINT ["/prntenv"]
