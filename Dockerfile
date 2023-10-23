# syntax=docker/dockerfile:1

ARG GO_VERSION=1.21.0
FROM golang:${GO_VERSION} AS build
# enable scanning for the intermediate build stage
ARG BUILDKIT_SBOM_SCAN_STAGE=true
WORKDIR /src

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=go.sum,target=go.sum \
    --mount=type=bind,source=go.mod,target=go.mod \
    go mod download -x

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,target=. \
    CGO_ENABLED=0 go build -o /bin/server .

FROM ubuntu@sha256:9b8dec3bf938bc80fbe758d856e96fdfab5f56c39d44b0cff351e847bb1b01ea AS final

# Install curl to bring CVE-2023-38545 (SOCKS5 heap buffer overflow)
# https://curl.se/docs/CVE-2023-38545.html
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl

COPY --from=build /bin/server /bin/

ENTRYPOINT [ "/bin/server" ]
