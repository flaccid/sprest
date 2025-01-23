DOCKER_REGISTRY = index.docker.io
IMAGE_NAME = sprest
IMAGE_VERSION = latest
IMAGE_ORG = flaccid
IMAGE_TAG = $(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)

WORKING_DIR := $(shell pwd)

COMMIT := $(shell git rev-parse HEAD)

.DEFAULT_GOAL := help

.PHONY: docker-release

deps:: ## installs go deps recursively
		@cd cmd/sprest && go get ./...

update-modules:: ## updates the go modules
		@cd cmd/sprest && go get -u ./... && go mod tidy

run:: ## runs the main program with go
		@go run cmd/sprest/sprest.go $(ARGS)

run-bin:: ## runs the built executable
		bin/sprest $(ARGS)

build:: ## builds the main program with go
		CGO_ENABLED=0 GOOS=linux go build \
			-ldflags="-X main.Commit=$(COMMIT)" \
			-o bin/sprest \
				cmd/sprest/sprest.go

docker-build:: ## builds the docker image locally
		@docker build \
			--pull \
			-t $(IMAGE_TAG) $(WORKING_DIR)

docker-build-no-cache:: ## builds the docker image locally (no cache)
		@docker build \
			--pull \
			--no-cache \
			-t $(IMAGE_TAG) $(WORKING_DIR)

docker-run:: ## runs the docker image locally
		docker run \
			-it \
			-v ~/.aws:/home/steampipe/.aws \
			-p 8080:8080 \
			--rm \
			$(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)

docker-run-debug:: ## runs the docker image locally (debug)
		docker run \
			-it \
			-v ~/.aws:/home/steampipe/.aws \
			-p 8080:8080 \
			--rm \
			$(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION) \
				/sprest -l debug

docker-pull:: ## pulls the docker image from the registry
		@docker pull $(IMAGE_TAG)

docker-push:: ## pushes the docker image to the registry
		@docker push $(IMAGE_TAG)

docker-release:: docker-build docker-push ## builds and pushes the docker image to the registry

print-commit:: ## prints the git commit
		@echo $(COMMIT)

# A help target including self-documenting targets (see the awk statement)
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
endef
export HELP_TEXT
help: ## this help target
	@cat .banner
	@echo
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
