FROM alpine:3.18.4@sha256:eece025e432126ce23f223450a0326fbebde39cdf496a85d8c016293fc851978 AS base

FROM scratch

HEALTHCHECK NONE

COPY --from=base /etc/passwd /etc/passwd
COPY --from=base /etc/group /etc/group
COPY --chown=65534:0 prntenv /

USER nobody

ENTRYPOINT ["/prntenv"]
