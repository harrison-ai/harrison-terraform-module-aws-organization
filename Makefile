fmt:
	docker-compose run --rm terraform fmt -recursive

tf-shell:
	docker-compose run --rm terraform /bin/ash

pull:
	docker-compose pull

docs:
	docker-compose run --rm terraform-docs terraform-docs-replace-012 md README.md
