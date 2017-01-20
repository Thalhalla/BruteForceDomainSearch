all:
	perl -Mlib::xi bruteforcedomainsearch.pl --startingNumber 6 --finishingNumber 8 --throttle 10 --sleepthrottle 5 -vvvvvv

reqs:
	sudo apt-get install -y cpanminus
	cpanm lib::xi

quick:
	perl bruteforcedomainsearch.pl --startingNumber 2 --finishingNumber 10 --throttle 33 --sleepthrottle 1 -vvvvv
