FROM golang:1.20.7@sha256:37c7d8580e0616e96914a67291b9693fe038ab677eb9b5deb81e541b2322f20f AS build

WORKDIR /build
COPY . /build

RUN go mod download && go mod verify

ENV CGO_ENABLED=0

RUN go build -ldflags="-w -s" -v -x -o prntenv ./cmd/prntenv/ && \
  strip prntenv

FROM gruebel/upx:latest AS upx
COPY --from=build /build/prntenv /prntenv

RUN upx -q -9 prntenv

FROM scratch

COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

COPY --from=upx --chown=65534:0 /prntenv /prntenv

USER nobody

ENTRYPOINT ["/prntenv"]
