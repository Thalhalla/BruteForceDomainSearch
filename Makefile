.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container
	@echo ""   2. make build     - build docker container
	@echo ""   3. make clean     - kill and remove docker container
	@echo ""   4. make enter     - execute an interactive bash in docker container
	@echo ""   5. make logs      - follow the logs of docker container
	@echo ""   6. make a         - build, run, and watch the logs macro

a: build run logs

build: NAME TAG builddocker

# run a plain container
run: rm rundocker

debug: rm debugdocker

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	-d \
	-P \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(shell which docker):/bin/docker \
	-t $(TAG)
	echo "later check $(TMP)/domlog"

debugdocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	-d \
	-P \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(shell which docker):/bin/docker \
	-t $(TAG) test

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker -l fatal kill `cat cid`

rm-image:
	-@docker -l fatal rm `cat cid`
	-@rm cid

rm: kill rm-image

clean: rm

enter:
	docker exec -i -t `cat cid` /bin/bash

logs:
	docker logs -f `cat cid`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;

full:
	perl bruteforcedomainsearch.pl --startingNumber 1 --finishingNumber 10 --throttle 10 --sleepthrottle 1 --forks 9 -v

reqs:
	sudo apt-get install -y cpanminus
	cpanm lib::xi

quick:
	perl bruteforcedomainsearch.pl --startingNumber 1 --finishingNumber 10 --throttle 99 --sleepthrottle 1 --forks 11 -v

q: quick

test:
	perl bruteforcedomainsearch.pl --startingNumber 1 --finishingNumber 1 --throttle 33 --sleepthrottle 1 --forks 0 -vvvvvvvvvv

short:
	perl bruteforcedomainsearch.pl --startingNumber 1 --finishingNumber 2 --throttle 99 --sleepthrottle 1 --forks 11 -v
