.DEFAULT_GOAL := usage
IMAGE_NAME=nouchka/symfony
DOCKER_TAG=latest

version-latest:
	DOCKER_TAG=latest IMAGE_NAME=$(IMAGE_NAME):$(DOCKER_TAG) ./hooks/build

version:
	DOCKER_TAG=$(DOCKER_TAG) IMAGE_NAME=$(IMAGE_NAME):$(DOCKER_TAG) ./hooks/build

usage:
	echo make version-latest $(DOCKER_TAG)
	echo make version DOCKER_TAG=5
