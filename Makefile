all:
	perl -Mlib::xi bruteforcedomainsearch.pl --startingNumber 6 --finishingNumber 8 --throttle 10 --sleepthrottle 5 -vvvvvv

reqs:
	sudo apt-get install -y cpanminus
	cpanm lib::xi
