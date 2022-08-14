# build args
SERVICE_NAME		?=	shop-service
VERSION			?=	latest
REGISTRY		?=	test
IMG			?=	$(REGISTRY)/$(SERVICE_NAME):$(VERSION)

# helpful things
CID 			?= 	$(shell docker ps --no-trunc -aqf name=$(SERVICE_NAME))
BUILD_TIME 		?= 	$(shell date -u +%Y-%m-%dT%H:%M:%SZ)
COMMIT_SHA 		?= 	$(shell git rev-parse HEAD)

local: local-build local-start

# build docker container
local-build:
	@clear
	@echo "Building an image"
	@docker build -t $(IMG) --build-arg REGISTRY=$(REGISTRY) .
	@docker tag $(REGISTRY)/$(SERVICE_NAME) test-shop

local-start:
	@clear
	@echo "Running container"
	@docker run --rm --name $(SERVICE_NAME) --network test --ip 194.168.0.3 -p 9000:9000/tcp $(IMG)

stop:
	@docker stop $(CID)

# build docker image
image:
	@docker build --no-cache -t $(IMG) \
           --build-arg BUILD_TIME=$(BUILD_TIME) \
           --build-arg COMMIT_SHA=$(COMMIT_SHA) \
           --build-arg VERSION=$(VERSION)       \
           --build-arg REGISTRY=$(REGISTRY)  \
           .

# push docker image
push: image
	docker push $(IMG)
