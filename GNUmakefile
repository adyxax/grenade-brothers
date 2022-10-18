SHELL:=bash

.PHONY: build
build: ## make build  # Builds a cartridge
	zig build

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## make init  # initialize project dependencies
	npm install wasm4
	rm package.json package-lock.json  # w4 will think it is an AssemblyScript game if we leave these files

.PHONY: serve
serve: ## make serve  # run a nodejs web server
	node_modules/.bin/w4 watch --no-open --no-qr

.DEFAULT_GOAL := help
