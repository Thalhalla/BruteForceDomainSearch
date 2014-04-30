#! /usr/bin/perl
use Data::Dumper;
use Net::DNS;
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
my $n = <STDIN>;
print "Please type in how many letters you want to test in DNS: ";
my $limit = <STDIN>;
print "Please type in the top level domain you'd like to brute force ";
my $tld = <STDIN>;
my $count = 1;
my $domain_word = '';
while( $count <= $limit ){

    my @chars = qw( a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 );
    push(@chars, '-');
    my @n = @chars;
    my $combinat = Math::Combinatorics->new(count => $n,
                                          data => [@n],
                                         );

    while(my @combo = $combinat->next_combination){
        $domain_word = '';
        foreach my $domain_char (@combo){
             $domain_word .= $domain_char;
        }
        if( "$domain_word" !~ m/^-.*/ && $domain_word !~ m/.*-$/ ){
            $domain_word .= $tld;
            #print "$domain_word\n";
            my $query = $res->search($domain_word);
            if ($query) {
                #foreach my $rr ($query->answer) {
                    #next unless $rr->type eq "A";
                    #print $rr->address, "\n";
                #}
            } else {
                #print "$domain_word\n";
                #my $return_output = `whois $domain_word |grep 'No match for'`;
                #my $return_output = whois($domain_word);
                #my @r = split(/\n/, $s);
                #my @t = grep { $_ =~ m/No\ match/} @r;
                my $return_output  = grep { $_ =~ m/No\ match/} split(/\n/,  whois($domain_word));
                if($return_output){
                    print "$domain_word is available ";
                    open(LOG, ">>~/domlog");
                    print LOG "$domain_word\n";
                    print "$return_output\n";
                }
                #warn "query failed: ", $res->errorstring, "\n";
                #print "$return_output\n";
            }
        }
    }

    output:
    $count++;
    $n++;
}
