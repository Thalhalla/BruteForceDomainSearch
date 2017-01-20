all:
	perl -Mlib::xi bruteforcedomainsearch.pl --startingNumber 6 --finishingNumber 8 --throttle 10 --sleepthrottle 5 --forks 3 -vvvvvv

reqs:
	sudo apt-get install -y cpanminus
	cpanm lib::xi

quick:
	perl bruteforcedomainsearch.pl --startingNumber 1 --finishingNumber 10 --throttle 99 --sleepthrottle 1 --forks 11 -v

q: quick

test:
	perl bruteforcedomainsearch.pl --startingNumber 1 --finishingNumber 1 --throttle 33 --sleepthrottle 1 --forks 0 -vvvvvvvvvv
