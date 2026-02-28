.PHONY: help up down logs test lint format tf-fmt tf-validate

help:
	@echo "Targets: up down logs test lint format tf-fmt tf-validate"

up:
	docker compose up --build -d

down:
	docker compose down

logs:
	docker compose logs -f --tail=200

test:
	docker compose run --rm api pytest -q

lint:
	docker compose run --rm api python -m py_compile app/*.py

format:
	@echo "No formatter configured yet. Add ruff/black if desired."

tf-fmt:
	cd infra/terraform && terraform fmt -recursive

tf-validate:
	cd infra/terraform && terraform init -backend=false && terraform validate
