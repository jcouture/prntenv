export DOCKER_SCAN_SUGGEST := "false"

docker_tag := `git rev-parse HEAD`
# docker_tag := `git describe --tags --abbrev=0`
docker_local_image := "jcouture/prntenv:" + docker_tag

# Run Aqua Security’s Trivy to catch possible vulnerabilities in the codebase
@audit:
  docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v {{justfile_directory()}}:/path aquasec/trivy fs --scanners config,secret,vuln /path

# Run Aqua Security’s Trivy to catch possible vulnerabilities in the Docker image
@docker-audit: docker-build
  docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image {{docker_local_image}}

# Build the Docker image
@docker-build:
  docker build --rm --progress plain --tag {{docker_local_image}} .

# Inspect the content of the Docker image
@docker-inspect: docker-build
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest {{docker_local_image}}

# Run `prntenv` as the final Docker image with optional arguments
@docker-run *ARGS: docker-build
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock {{docker_local_image}} {{ARGS}}

# Update dependencies
@go-mod-update:
  go get -u
  go mod tidy

# Dry-run GoReleaser
@release-dry-run:
  goreleaser --snapshot --skip-publish --clean

# Launch the executable with optional arguments
@run *ARGS:
  go run ./cmd/prntenv/prntenv.go {{ARGS}}

# Git tag a version
@tag VERSION:
  git tag -a {{VERSION}} -s -m "{{VERSION}}"
