APP := $(notdir $(shell echo $(PWD) | tr A-Z a-z))
maker_versioned := "riazarbi/$(APP):$$(date +"%Y%m%d")"
maker_latest := riazarbi/$(APP):latest
binder_versioned := "riazarbi/$(APP)_dev:$$(date +"%Y%m%d")"
binder_latest := riazarbi/$(APP)_dev:latest

maker_run := docker run --rm --mount type=bind,source="$(shell pwd)/",target=/home/maker/ $(maker_latest)
binder_run := docker run --rm -p 8888:8888 --user=root --mount type=bind,source="$(shell pwd)/",target=/home/maker/ $(binder_versioned)
binder_dev := docker run -it --rm --name debug --rm -p 8888:8888 --mount type=bind,source="$(shell pwd)/",target=/home/maker/ $(binder_versioned)


.DEFAULT_GOAL := help

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: maker-build
maker-build: ## Build docker container with required dependencies
	docker build --no-cache -t $(maker_versioned) .
	docker image tag $(maker_versioned) $(maker_latest)

.PHONY: binder-build
binder-build:  maker-build ## Build docker container with required dependencies
	cd binder; \
	docker build --no-cache -t $(binder_versioned) . ; \
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

build: push  ## Build all images and push to docker hub
	echo $(maker_versioned) > latest

.PHONY: debug
debug: ## Launch an interactive cli environment
	$(maker_run) /bin/bash

.PHONY: dev
dev: ## Launch an interactive browser based IDE
	$(binder_dev) jupyter lab  --NotebookApp.default_url="/rstudio" --no-browser --NotebookApp.token=a2ff4e8772f46374f3c6ef9d4893dacf5e933f274cf151e0 --port=8888 --ip=0.0.0.0
