DOCKER_IMAGE=symfony
DOCKER_NAMESPACE=nouchka

.DEFAULT_GOAL := build
VERSIONS=5 7.0 7.3

build-latest:
	$(MAKE) -s build-version VERSION=latest

build-version:
	@chmod +x ./hooks/build
	DOCKER_TAG=$(VERSION) IMAGE_NAME=$(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) ./hooks/build

.PHONY: build
build: build-latest
	$(foreach version,$(VERSIONS), $(MAKE) -s build-version VERSION=$(version);)

.PHONY: test
test:
	docker-compose -f docker-compose.test.yml up
