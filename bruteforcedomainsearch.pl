#! /usr/bin/perl
use Data::Dumper;
use Net::DNS;
 use Algorithm::Permute;
use Math::Combinatorics;
use warnings;
use strict;
use Net::Whois::Raw qw( whois $OMIT_MSG $CHECK_FAIL $CACHE_DIR $CACHE_TIME $USE_CNAMES $TIMEOUT );
my $OMIT_MSG = 2; # This will try some additional stripping rules
my $CHECK_FAIL = 2; # This will match against several more rules
my $CACHE_DIR = "/var/spool/pwhois/"; # Whois information will be
my $CACHE_TIME = 24; # Cache files will be cleared after not accessed
my $USE_CNAMES = 1; # Use whois-servers.net to get the whois server
my $TIMEOUT = 10; # Cancel the request if connection is not made within
my $res   = Net::DNS::Resolver->new;

print "Please type in how many letters you want to start with: ";
chomp( my $n = <STDIN>);
print "Please type in how many letters you want to test in DNS: ";
chomp( my $limit = <STDIN>);
print "Please type in the top level domain you'd like to brute force [i.e. .com]";
chomp( my $tld = <STDIN>);
my $domain_word = '';
while( $n <= $limit ){

    my @n = qw( a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 );
    push(@n, '-');
    #my $combinat = new Algorithm::Permute(@n, $n);
    my $combinat = new Algorithm::Permute(['a'..'z', '-'], $n);

    while(my @combo = $combinat->next){
        my $permutation = Math::Combinatorics->new(count => $n, data => [@combo], );
            $domain_word = '';
            foreach my $domain_char (@combo){
                 $domain_word .= $domain_char;
            }
            if( "$domain_word" !~ m/^-.*/ && $domain_word !~ m/.*-$/ ){
                #$domain_word .= $tld;
                print "$domain_word\n";
                my $query = $res->search($domain_word);
                if ($query) {
                    #foreach my $rr ($query->answer) {
                        #next unless $rr->type eq "A";
                        #print $rr->address, "\n";
                    #}
                } else {
                    #print "$domain_word\n";
                    my $return_output  = grep { $_ =~ m/No\ match/} split(/\n/,  whois($domain_word));
                    if($return_output){
                        print "$domain_word is available ";
                        open(LOG, ">>/tmp/domlog") or warn "cant open log $!";
                        print LOG "$domain_word\n";
                        close LOG or warn "cant close log $!";
                        print "$return_output\n";
                    }
                }
            }
    }
    $n++;
}
