SHELL:=bash
REVISION=$(shell git rev-parse HEAD)

.PHONY: build
build: ## make build	# Builds a cartridge
	zig build -Drelease-small=true

.PHONY: buildah
buildah: ## make buildah	# Builds the container image
	deploy/build-image.sh

.PHONY: deploy
deploy: ## make deploy	# deploy the cartridge the active kubernetes context
	sed -i deploy/kubernetes.yaml -e 's/^\(\s*image:[^:]*:\).*$$/\1$(REVISION)/'
	kubectl apply -f deploy/kubernetes.yaml

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## make init	# initialize project dependencies
	npm install wasm4
	rm package.json package-lock.json  # w4 will think it is an AssemblyScript game if we leave these files

.PHONY: push
push: ## make push	# push the built image to quay.io
	buildah push adyxax/grenade-brothers quay.io/adyxax/grenade-brothers:$(REVISION)

.PHONY: run
run: ## make run	# run a nodejs web server
	node_modules/.bin/w4 run --port 80 --no-open --no-qr zig-out/lib/cart.wasm

.PHONY: serve
serve: ## make serve	# run a nodejs development web server that watches the code file and recompiles upon changes
	node_modules/.bin/w4 watch --no-open --no-qr

.DEFAULT_GOAL := help
