# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

APP_NAME				:= spring-prometheus
DOCKER_ACCOUNT	:= boeboe
VERSION					:= 1.0.0

K8S_NAMESPACE		:= spring-prometheus

mvn-clean: ## Clean Maven build artifacts
	cd application && mvn clean

mvn-compile: mvn-clean ## Compile the source code with Maven
	cd application && mvn compile

mvn-package: mvn-clean ## Take the compiled code and package it with Maven
	cd application && mvn package

mvn-run: mvn-clean ## Run the application with Maven
	cd application && mvn package spring-boot:run

docker-build: ## Build container
	docker build --build-arg JAR_FILE=application/target/*.jar --no-cache -t $(DOCKER_ACCOUNT)/$(APP_NAME) .

docker-run: ## Run container
	docker run -it --rm -p 8080:8080 --name="$(APP_NAME)" $(DOCKER_ACCOUNT)/$(APP_NAME)

docker-clean: ## Remove container
	docker rm $(APP_NAME) || true
	docker rmi $(DOCKER_ACCOUNT)/$(APP_NAME) || true
	docker rmi $(DOCKER_ACCOUNT)/$(APP_NAME):$(VERSION) || true

docker-publish: ## Tag and publish container
	docker tag $(DOCKER_ACCOUNT)/$(APP_NAME) $(DOCKER_ACCOUNT)/$(APP_NAME):$(VERSION)
	docker tag $(DOCKER_ACCOUNT)/$(APP_NAME) $(DOCKER_ACCOUNT)/$(APP_NAME):latest
	docker push $(DOCKER_ACCOUNT)/$(APP_NAME):$(VERSION)
	docker push $(DOCKER_ACCOUNT)/$(APP_NAME):latest

release: mvn-package docker-build docker-publish ## Make a full release

clean: mvn-clean docker-clean  ## Clean all build artifacts

k8s-deploy: ## Deploy in kubernetes
	kubectl create namespace ${K8S_NAMESPACE} || true
	kubectl label namespace ${K8S_NAMESPACE} istio-injection=enabled || true
	kubectl -n ${K8S_NAMESPACE} apply -f ./kubernetes
	sleep 10 && kubectl -n ${K8S_NAMESPACE} wait --timeout=2m --for=condition=Ready pods --all

k8s-remove: ## Remove deployment in kubernetes
	kubectl -n ${K8S_NAMESPACE} delete -f ./kubernetes
	kubectl delete namespace ${K8S_NAMESPACE}
