BruteForceDomainSearch
======================

Brute Force Domain Search

Of note this is "brute force" and is likely to get you banned ten ways from Sunday!  Do not ever run this script as it will destroy your computer and set fire to whatever dwelling you currently inhabit!
You've been warned (I've added some throttling and a block of public DNS servers but this is still a brute force script)
Not much to see here, does what it says on the tin , e.g.
it will start dumping out available domain names into STDOUT and /tmp/domlog
some example usage:

perl bruteforcedomainsearch.pl --startingNumber 6 --finishingNumber 8 --throttle 10 --sleepthrottle 5 -vvvvvv

that will hunt down all available 6, 7, and 8 letter domains available and limit you to ten requests with each resolver before sleeping for five seconds  (roundabouts it was a simple throttle nothing fancy)
