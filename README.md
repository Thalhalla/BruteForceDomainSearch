BruteForceDomainSearch
======================

Brute Force Domain Search - a bit of perl to help you find open domain
names that are available for purchase

### Usage

bruteforcedomainsearch.pl [--startingNumber 6 --finishingNumber 8 --throttle 10 --sleepthrottle 5 -vvvvvvvvvv]

* Args
	+ --startingNumber # The number of letters we will start iterating from (i.e. 1 = a.com, 5 = aaaaa.com)
	+ --finishingNumber # The number of letters we will finish iterating at (i.e. 1 = a.com, 5 = aaaaa.com)
	+ --throttle # This is the number of loops to hit the Nameservers with before sleeping
	+ --sleepthrottle # This is the number of seconds to sleep once we hit the throttle
	+ -v # verbosity (notice you can stack more v's at the end to get more verbosity)
	+ -vvvvvvvvv\t# Really verbose

### Notes

Of note this is "brute force" and is likely to get you banned ten ways from Sunday!  Do not ever run this script as it will destroy your computer and set fire to whatever dwelling you currently inhabit!
You've been warned (I've added some throttling and a block of public DNS servers but this is still a brute force script)
Not much to see here, does what it says on the tin , e.g.
it will start dumping out available domain names into STDOUT and /tmp/domlog
some example usage:

./bruteforcedomainsearch.pl --startingNumber 6 --finishingNumber 8 --throttle 10 --sleepthrottle 5 -vvvvvv

that will hunt down all available 6, 7, and 8 letter domains available and limit you to ten requests with each resolver before sleeping for five seconds  (roundabouts it was a simple throttle nothing fancy)

### Makefile

* `make full`
	+  full rundown from 1 to 10 letters

* `make xi`  
	+  will do the same as above and install any dependencies using `lib::xi`

* `make reqs`
	+  will install cpanminus and then `lib::xi` in debian

### Docker

Most of this section works by virtue of the `--cidfile="cid"` option to
the `docker run` command

* `tmp/domlog`
	+ Using the Makefile to create the docker container will result in a `tmp` directory here, which will contain the resulting `/tmp/domlog` from inside the container, so no need to go into the container to retrieve it

* `make a`
	+  A macro which builds a docker image locally, runs it and displays the
logs

* `make build`
	+  builds a docker image locally

* `make log`
	+  shows logs of the running docker

* `make run`
	+  runs a docker image locally

* `make clean`
	+  kills and removes the docker container
