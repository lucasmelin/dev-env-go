# Pin the image to the platform the builder is running on
FROM --platform=${BUILDPLATFORM} golang:1.18.7 AS base
# Working directory in the container
WORKDIR /src
# Statically compile, don't rely on linked C libraries
ENV CGO_ENABLED=0
# Download the modules so they can be cached
COPY go.* .
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download
# Copy the rest of the files from the host to the container
COPY . .


FROM base AS build
# Fill the OS and ARCH using the BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
# Build the binary, mounting the Go compiler cache
RUN --mount=type=cache,target=.,target=/go/pkg/mod,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/example .


FROM base AS unit-test
# Run the unit tests, mounting the Go compiler cache
RUN --mount=type=cache,target=.,target=/go/pkg/mod,target=/root/.cache/go-build \
    go test -v .

FROM golangci/golangci-lint:v1.50 AS lint-base

FROM base AS lint
RUN --mount=target=.,from=lint-base,src=/usr/bin/golangci-lint,target=/usr/bin/golangci-lint \
    --mount=type=cache,target=/go/pkg/mod,type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/.cache/golangci-lint \
    golangci-lint run --timeout 10m0s ./...

# Copy stage for unix
FROM scratch AS bin-unix
# Copy the binary from the first stage to the filesystem
COPY --from=build /out/example /

# Aliases for other unix-like OSes
FROM bin-unix AS bin-linux
FROM bin-unix AS bin-darwin

# Copy stage for Windows
FROM scratch AS bin-windows
COPY --from=build /out/example /example.exe

# Dynamic target that is set by the platform flag
FROM bin-${TARGETOS} AS bin