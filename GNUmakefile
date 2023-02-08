.DEFAULT_GOAL := help
SHELL:=bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

REVISION=$(shell git rev-parse HEAD)

.PHONY: build
build: zig-out/lib/cart.wasm ## make build		# Builds a cartridge

.PHONY: buildah
buildah: ## make buildah	# Builds the container image
	deploy/build-image.sh

.PHONY: clean
clean: ## make clean		# Cleans build files
	rm -rf zig-cache zig-out

.PHONY: depclean
depclean: clean ## make depclean	# Cleans build files and node dependencies
	rm -rf node_modules

.PHONY: deploy
deploy: ## make deploy	# deploy the cartridge to the active kubernetes context
	sed -i deploy/kubernetes.yaml -e 's/^\(\s*image:[^:]*:\).*$$/\1$(REVISION)/'
	kubectl apply -f deploy/kubernetes.yaml

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: node_modules ## make init		# initialize project dependencies

node_modules: README.md
	npm install wasm4
	rm package.json package-lock.json  # w4 will think it is an AssemblyScript game if we leave these files
	                                   # because of that this make target depends on the README which lists the wasm4 version

.PHONY: push
push: ## make push		# push the built image to quay.io
	buildah push adyxax/grenade-brothers quay.io/adyxax/grenade-brothers:$(REVISION)

.PHONY: run
run: node_modules  build ## make run		# run a nodejs production web server
	node_modules/.bin/w4 run --port 80 --no-open --no-qr zig-out/lib/cart.wasm

.PHONY: serve
serve: node_modules ## make serve		# run a nodejs development web server that watches the code files and recompiles upon changes
	node_modules/.bin/w4 watch --no-open --no-qr

zig-out/lib/cart.wasm:  build.zig  $(wildcard src/*.zig)
	zig build -Drelease-small=true
