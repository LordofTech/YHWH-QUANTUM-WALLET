
.PHONY: deploy-cloud helm-install kube-wait

ENV ?= staging
PROVIDER ?= aws # aws|gcp|azure
IMAGE ?= ghcr.io/owner/quantum-wallet-backend
TAG ?= latest

deploy-cloud: ## One command deploy: make deploy-cloud PROVIDER=aws|gcp|azure ENV=staging
	@echo "Deploying to $(PROVIDER) $(ENV)"
	@if [ "$(PROVIDER)" = "aws" ]; then \
		echo "Use terraform/aws-eks and kubectl apply"; \
	elif [ "$(PROVIDER)" = "gcp" ]; then \
		echo "Use terraform/gcp-gke and kubectl apply"; \
	elif [ "$(PROVIDER)" = "azure" ]; then \
		echo "Use terraform/azure-aks and kubectl apply"; \
	else \
		echo "Unknown PROVIDER=$(PROVIDER)"; exit 1; \
	fi
	$(MAKE) helm-install

helm-install:
	helm upgrade --install otel ./helm/otel-collector -n quantum-wallet --create-namespace
	helm upgrade --install api  ./helm/quantum-wallet-api -n quantum-wallet --set image.repository=$(IMAGE) --set image.tag=$(TAG)

kube-wait:
	kubectl -n quantum-wallet rollout status deploy/quantum-wallet-api --timeout=180s
