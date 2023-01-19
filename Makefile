maker_versioned := "riazarbi/maker:$$(date +"%Y%m%d")"
maker_latest := riazarbi/maker:latest
ide_versioned := "riazarbi/maker_ide:$$(date +"%Y%m%d")"
ide_latest := riazarbi/maker_ide:latest

maker_run := docker run --rm --mount type=bind,source="$(shell pwd)/",target=/root/ $(maker_versioned)
ide_run := docker run --rm -p 8888:8888 --mount type=bind,source="$(shell pwd)/",target=/home/maker/ $(ide_versioned)

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: maker-build
maker-build: ## Build docker container with required dependencies
	docker build --no-cache -t $(maker_versioned) .
	docker image tag $(maker_versioned) $(maker_latest)

.PHONY: ide-build
ide-build: maker-build ## Build docker container with required dependencies
	cd ide; \
	docker build --no-cache -t $(ide_versioned) . ; \
	docker image tag $(ide_versioned) $(ide_latest)

.PHONY: test
test: ide-build ## Run tests
	$(maker_run) R -e 'print("R WORKS")'
	$(maker_run) python -c 'print("PYTHON WORKS")'
	$(ide_run) rstudio-server version
	$(ide_run) jupyter kernelspec list


.PHONY: docker-push
docker-push: test ## Push docker container to Docker Hub
	docker push $(maker_versioned); \
	docker push $(maker_latest); \
	docker push $(ide_versioned); \
	docker push $(ide_latest)

run: docker-push  ## Create a file in repo recording date of last push
	echo $(maker_versioned) > latest
	
.PHONY: debug
debug: ## Launch an interactive environment
	$(ide_run) jupyter notebook --NotebookApp.default_url=/lab/ --no-browser --ip=0.0.0.0 --port=8888
