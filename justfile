# Run Aqua Security’s Trivy to catch possible vulnerabilities in the codebase
@audit:
  docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v {{justfile_directory()}}:/path aquasec/trivy fs --scanners config,secret,vuln /path

# Update dependencies
@go-mod-update:
  go get -u
  go mod tidy

# Launch the executable with optional arguments
@run *ARGS:
  go run ./cmd/prntenv/prntenv.go {{ARGS}}
