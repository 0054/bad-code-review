
ECR_URL := 1234567890.dkr.ecr.us-east-1.amazonaws.com/my-app
TAG ?= latest
COMMIT_HASH := $(shell git rev-parse --short HEAD)


print-hash:
	@echo $(COMMIT_HASH)

print-image-name:
	@echo $(ECR_URL)

build_local:
	docker build -f imagefile -t ${ECR_URL}:${TAG} .

build:
	./build.sh $(TAG) $(ECR_URL) $(COMMIT_HASH)

run_tests:
	pytest tests/

push:
	docker push ${ECR_URL}:${TAG}

aws_login:
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 1234567890.dkr.ecr.us-east-1.amazonaws.com