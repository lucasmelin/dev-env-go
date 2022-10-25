## Dev Environment for Go

A mostly self-contained dev environment for [Go](https://go.dev/).

### Installation

```sh
brew install --cask docker
brew install go-task/tap/go-task
```

## Commands

To run the build:

```sh
task build
# Specify a platform like windows/amd64
task build PLATFORM=windows/amd64
```

You can then run the binary:

```sh
./bin/example "what smells like blue?"
```

To run the linter:

```sh
task lint
```

To run the unit tests:

```sh
task unit-test
```