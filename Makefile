##Usage: make <command>
##
##Commands:
IMAGE_NAME := $(shell grep "ARG NAME" ./Dockerfile | cut -d'"' -f2)
CONTAINER_NAME := $(shell grep "ARG NAME" ./Dockerfile | cut -d'"' -f2 | sed 's/\//-/g')
IMAGE_VERSION := $(shell grep "ARG VERSION" ./Dockerfile | cut -d'"' -f2)

.PHONY: build serve help

default: help

build:			## Build docker image
	@echo "Build $(IMAGE_NAME) v$(IMAGE_VERSION)..."
	@docker build -t "$(IMAGE_NAME)" ./
	@docker tag "$(IMAGE_NAME)" "$(IMAGE_NAME):$(IMAGE_VERSION)"
	@echo "Create image $(IMAGE_NAME):$(IMAGE_VERSION) done."

serve:			## Start docker image locally
	@docker run -it --rm -p 9091:9091 -p 51413:51413 -e PASSWORD=TestPass -v ${HOME}/Downloads:/downloads --name "$(CONTAINER_NAME)" "$(IMAGE_NAME)"

help:			## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
