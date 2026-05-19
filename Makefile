setup:
	./scripts/setup-kind.sh

build:
	docker build -t sample-app:latest ./app

load:
	kind load docker-image sample-app:latest --name platform-assignment

deploy:
	kubectl apply -f k8s/base

rbac:
	kubectl apply -f k8s/rbac

argocd-install:
	./scripts/install-argocd.sh

test:
	cd app && npm ci && npm test

run:
	cd app && npm start