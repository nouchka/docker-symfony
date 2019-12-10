DOCKER_IMAGE=symfony
DOCKER_NAMESPACE=nouchka

.DEFAULT_GOAL := build
VERSIONS=5 7.0 7.3

build-latest:
	$(MAKE) -s build-version VERSION=latest

build-beta:
	$(MAKE) -s build-version VERSION=beta

build-version:
	@chmod +x ./hooks/build
	DOCKER_TAG=$(VERSION) IMAGE_NAME=$(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) ./hooks/build
	docker run -it --rm --entrypoint php $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) -v > packages.$(VERSION).tmp
	docker run -it --rm --entrypoint php $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) -m >> packages.$(VERSION).tmp

.PHONY: build
build: build-latest
	$(foreach version,$(VERSIONS), $(MAKE) -s build-version VERSION=$(version);)

.PHONY: test
test:
	docker-compose -f docker-compose.test.yml up

.PHONY: check
check: 
	$(foreach version,$(VERSIONS), $(MAKE) -s check-version VERSION=$(version);)

.PHONY: check-version
check-version:
	docker run --rm --entrypoint symfony nouchka/symfony:$(VERSION) -V

.PHONY: clean
clean: 
	$(foreach version,$(VERSIONS), $(MAKE) -s clean-version VERSION=$(version);)

.PHONY: clean-version
clean-version:
	docker rmi nouchka/symfony:$(VERSION)
