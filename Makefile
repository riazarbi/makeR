versioned_tag := "riazarbi/maker:$$(date +"%Y%m%d")"
latest_tag := riazarbi/maker:latest

docker_run := docker run --rm --mount type=bind,source="$(shell pwd)/",target=/root/ $(versioned_tag)

.DEFAULT_GOAL := docker-push

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: docker-build
docker-build: ## Build docker container with required dependencies
	docker build -t $(versioned_tag) .
	$(docker_run) echo DONE
	docker build -t $(latest_tag) .

.PHONY: test
test: docker-build ## Run tests
	$(docker_run) echo DONE

.PHONY: docker-push
docker-push: test ## Push docker container to Docker Hub
	docker push $(versioned_tag)
	docker push $(latest_tag) 

run: docker-push  ## Create a file in repo recording date of last push
	cat versioned_tag > 