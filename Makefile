maker_versioned := "riazarbi/maker:$$(date +"%Y%m%d")"
maker_latest := riazarbi/maker:latest
binder_versioned := "riazarbi/maker_binder:$$(date +"%Y%m%d")"
binder_latest := riazarbi/maker_binder:latest

maker_run := docker run --rm --mount type=bind,source="$(shell pwd)/",target=/home/maker/ $(maker_versioned)
binder_run := docker run --name debug --rm -p 8888:8888 --user=root --mount type=bind,source="$(shell pwd)/",target=/home/maker/ $(binder_versioned)

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: maker-build
maker-build: ## Build docker container with required dependencies
	docker build --no-cache -t $(maker_versioned) .
	docker image tag $(maker_versioned) $(maker_latest)

.PHONY: binder-build
binder-build: maker-build ## Build docker container with required dependencies
	cd binder; \
	docker build  --no-cache -t $(binder_versioned) . ; \
	docker image tag $(binder_versioned) $(binder_latest)

.PHONY: test
test: binder-build ## Run tests
	$(maker_run) R -e 'print("R WORKS")'
	$(maker_run) python -c 'print("PYTHON WORKS")'
	$(binder_run) rstudio-server version
	$(binder_run) jupyter kernelspec list

.PHONY: push
push: test ## Push docker container to Docker Hub
	docker push $(maker_versioned); \
	docker push $(maker_latest); \
	docker push $(binder_versioned); \
	docker push $(binder_latest)

run: push  ## Build all images and push to docker hub
	echo $(maker_versioned) > latest

.PHONY: debug
debug: ## Launch an interactive environment
	$(binder_run) jupyter notebook --allow-root --NotebookApp.default_url=/lab/ --no-browser --ip=0.0.0.0 --port=8888
