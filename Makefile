.DEFAULT_GOAL := default

IMAGE ?= docker.cluster.fun/averagemarcus/talks:latest

.PHONY: test # Run all tests, linting and format checks
test: lint check-format run-tests

.PHONY: lint # Perform lint checks against code
lint:
	@echo "⚠️ 'lint' unimplemented"
	# GO Projects
	# @go vet && golint -set_exit_status ./...

.PHONY: check-format # Checks code formatting and returns a non-zero exit code if formatting errors found
check-format:
	@echo "⚠️ 'check-format' unimplemented"
	# GO Projects
	# @gofmt -e -l .

.PHONY: format # Performs automatic format fixes on all code
format:
	@echo "⚠️ 'format' unimplemented"
	# GO Projects
	# @gofmt -s -w .

.PHONY: run-tests # Runs all tests
run-tests:
	@echo "⚠️ 'run-tests' unimplemented"
	# GO Projects
	# @go test
	# Node Projects
	# @npm test

.PHONY: fetch-deps # Fetch all project dependencies
fetch-deps:
	@npm install -g @marp-team/marp-cli

.PHONY: build # Build the project
build: lint check-format fetch-deps
	@find . -maxdepth 2 -mindepth 2 -name "*.md" -not -name "README.md" -print0 | xargs -0 marp {} \;

.PHONY: docker-build # Build the docker image
docker-build:
	@docker build -t $(IMAGE) .

.PHONY: docker-publish # Push the docker image to the remote registry
docker-publish:
	@docker push $(IMAGE)

.PHONY: run # Run the application
run: docker-build
	@docker run --rm -it -p 8080:80 $(IMAGE)

.PHONY: ci # Perform CI specific tasks to perform on a pull request
ci:
	@echo "⚠️ 'ci' unimplemented"

.PHONY: release # Release the latest version of the application
release:
	@echo "⚠️ 'release' unimplemented"

.PHONY: help # Show this list of commands
help:
	@echo "talks"
	@echo "Usage: make [target]"
	@echo ""
	@echo "target	description" | expand -t20
	@echo "-----------------------------------"
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1	\2/' | expand -t20

default: test build
