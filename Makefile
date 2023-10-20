export PROJECT := sel_server
export BUILD_TAG := $(USER)


docker:			Dockerfile
	docker build -f Dockerfile --network host -t "$(PROJECT):$(BUILD_TAG)" .

docker-test:	docker Dockerfile.test
	docker build -f Dockerfile.test --build-arg BUILD_TAG=$(BUILD_TAG) --network host -t "$(PROJECT)_test:$(BUILD_TAG)" .

lint:			docker-test
	scripts/pylint.sh "$(PROJECT)_test:$(BUILD_TAG)" sel_server

tests:			docker-test
	docker-compose -f tests/docker-compose.yml up -d
	docker-compose -f tests/docker-compose.yml exec tests pytest --cov=sel_server -vvx tests
	docker-compose -f tests/docker-compose.yml down

upshell:		docker-test
	docker-compose -f tests/docker-compose.yml -f docker-compose.add_volumes.yml up -d
	docker-compose -f tests/docker-compose.yml -f docker-compose.add_volumes.yml exec tests bash
	docker-compose -f tests/docker-compose.yml down

clean:
	rm -rf sel_server/__pycache__ scripts/__pycache__
