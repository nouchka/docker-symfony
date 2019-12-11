DOCKER_IMAGE=symfony
VERSIONS=5 7.0 7.3

include Makefile.docker

.PHONY: check-version
check-version:
	docker run --rm --entrypoint symfony $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) -V
	docker run --rm --entrypoint php $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) -v
	docker run --rm --entrypoint php $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) -m
