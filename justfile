export DOCKER_SCAN_SUGGEST := "false"

bin := "prntenv"
docker_image := "ghcr.io/jcouture/prntenv"

[private]
default:
  @just --list --unsorted

# Run Aqua Security’s Trivy to catch possible vulnerabilities in the codebase
@audit:
  docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v {{justfile_directory()}}:/path aquasec/trivy fs --scanners config,secret,vuln /path

# Build prntenv’s executable
@build $GO_ENABLED="0": clean
  go mod download && go mod verify
  go build -ldflags="-w -s" -v -x -o {{bin}} ./cmd/prntenv

# Delete prntenv’s executable
@clean:
  rm -f {{bin}}

# Inspect the content of the Docker image
@docker-inspect:
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest {{docker_image}}

# List the Docker image labels
@docker-list-labels:
  docker inspect {{docker_image}} | jq '.[0].Config.Labels'

# Run `prntenv` as the final Docker image with optional arguments
@docker-run *ARGS:
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock {{docker_image}} {{ARGS}}

# Update dependencies
@go-mod-update:
  go get -d -u ./...
  go mod tidy

# Dry-run GoReleaser
@release-dry-run:
  goreleaser --snapshot --skip=publish --clean

# Launch the executable with optional arguments
@run *ARGS:
  go run ./cmd/prntenv/prntenv.go {{ARGS}}

# Git tag a version
@tag VERSION:
  git tag -a {{VERSION}} -s -m "{{VERSION}}"
