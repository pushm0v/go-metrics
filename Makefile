.PHONY: default help build package tag push helm helm-migration run test clean

APP_NAME      = go-metrics
BUILD_DATE    = $(shell date '+%Y-%m-%d-%H:%M:%S')

default: help

help:
	@echo 'Management commands for ${APP_NAME}:'
	@echo
	@echo 'Usage:'
	@echo '    make build                 Compile the project.'
	@echo '    make run ARGS=""           Run the project with ARGS if supplied.'
	@echo '    make test                  Run tests on a compiled project.'
	@echo '    make clean                 Clean the directory tree.'
	@echo '    make image                 Create container image.'
	@echo '    make image-run             Run container image.'

	@echo

build:
	@echo "Building ${APP_NAME}"
	go build -o bin/${APP_NAME}
run: build
	@echo "Running ${APP_NAME}"
	bin/${APP_NAME} ${ARGS}

test:
	@echo "Testing ${APP_NAME}"
	go test ./...

clean:
	@echo "Removing ${APP_NAME}"
	@test ! -e bin/${APP_NAME} || rm bin/${APP_NAME}

image:
	@echo "Creating container image ${APP_NAME}"
	docker build -t ${APP_NAME}:local .

image-run:
	@echo "Running container image ${APP_NAME}:local"
	docker run ${APP_NAME}:local

