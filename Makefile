export PROJECT := sel_server
export BUILD_TAG := $(USER)


docker:			Dockerfile
	docker build -t "$(PROJECT):$(BUILD_TAG)" .

docker-test:	docker tests/Dockerfile.test
	docker build -f tests/Dockerfile.test --build-arg BUILD_TAG=$(BUILD_TAG) -t "$(PROJECT)_test:$(BUILD_TAG)" .

lint:			docker-test
	scripts/pylint.sh "$(PROJECT)_test:$(BUILD_TAG)" sel_server

tests:			docker-test
	docker-compose -f tests/docker-compose.yml up -d
	docker-compose -f tests/docker-compose.yml exec tests pytest --cov=sel_server -vvx tests
	docker-compose -f tests/docker-compose.yml down

upshell:		docker-test
	docker-compose -f tests/docker-compose.yml -f tests/docker-compose.add_volumes.yml up -d
	docker-compose -f tests/docker-compose.yml -f tests/docker-compose.add_volumes.yml exec tests bash
	docker-compose -f tests/docker-compose.yml down

doc:	docker
	@echo "Getting latest documentation json ..."
	$(eval DID=$(shell docker run -p 9001:9000 -d sel_server:$(USER)))
	@sleep 2
	curl "http://localhost:9001/openapi.json" > docs/sel_server.json
	@docker stop $(DID)


clean:
	rm -rf sel_server/__pycache__ scripts/__pycache__
