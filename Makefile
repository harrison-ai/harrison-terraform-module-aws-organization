build:
	docker-compose build

fmt:
	docker-compose run --rm terraform fmt -recursive

tf-shell:
	docker-compose run --rm --entrypoint='' terraform /bin/bash

pull:
	docker-compose pull

docs:
	for module in $(shell find modules -maxdepth 1 -mindepth 1 -type d); do \
		docker-compose run --rm --workdir /app/$$module terraform-docs terraform-docs-replace-012 md README.md ; \
	done

diagram:
	docker-compose run --rm --entrypoint='python' terraform /app/scripts/diagram.py

uuid:
	docker-compose run --rm --entrypoint='python' terraform /app/scripts/generate-uuid.py
