GITCOMMIT := $(shell git rev-parse --short=7 HEAD 2>/dev/null)
NAME=dev

all: build

build:
	docker build -t yuanying/${NAME}:${GITCOMMIT} .
	docker tag yuanying/${NAME}:$(GITCOMMIT) yuanying/${NAME}:latest

push:
	@echo "==> Publishing yuanying/${NAME}:$(GITCOMMIT)"
	@docker push yuanying/${NAME}:$(GITCOMMIT)
	@docker push yuanying/${NAME}:latest
	@echo "==> Your image is now available at yuanying/${NAME}:$(GITCOMMIT)"

run: kill
	docker run -it -h dev \
		-d \
		-p 3222:3222 \
		-p 60000-60010:60000-60010 \
		--rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--cap-add=SYS_PTRACE \
		--security-opt seccomp=unconfined \
		--privileged \
		--name dev \
		yuanying/${NAME}:latest 

ssh:
	mosh --no-init --ssh="ssh -o StrictHostKeyChecking=no -i ~/.ssh/github_rsa -p 3222" yuanying@localhost -- tmux new-session -AD -s main

kill:
	docker kill dev | true


.PHONY: all build run kill
