docker_tag := riazarbi/maker:0.0.1
docker_run := docker run --rm --mount type=bind,source="$(shell pwd)/",target=/root/ $(docker_tag)

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: docker-build
docker-build: ## Build docker container with required dependencies
	docker build -t $(docker_tag) .
	$(docker_run) echo DONE

.PHONY: test
test: docker-build ## Run tests
	$(docker_run) echo DONE

.PHONY: docker-push
docker-push: test ## Push docker container to Docker Hub
	docker push $(docker_tag) 
