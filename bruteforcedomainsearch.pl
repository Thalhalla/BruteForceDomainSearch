#! /usr/bin/perl
use Data::Dumper;
use Net::DNS;
use Algorithm::Permute;
use v5.10;
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
my @resolver;
my $rescount = 0;
my $count = 0;
my $throttle = 10;
my $sleepthrottle = 1;
$resolver[0] = Net::DNS::Resolver->new( nameservers => [qw(8.8.8.8 8.8.4.4)], recurse => 1, debug => 0, );
$resolver[1] = Net::DNS::Resolver->new( nameservers => [qw(209.244.0.3 209.244.0.4)], recurse => 1, debug => 0, );
$resolver[2] = Net::DNS::Resolver->new( nameservers => [qw( 216.146.35.35 216.146.36.36  )], recurse => 1, debug => 0, );
$resolver[3] = Net::DNS::Resolver->new( nameservers => [qw( 8.26.56.26 8.20.247.20 )], recurse => 1, debug => 0, );
$resolver[4] = Net::DNS::Resolver->new( nameservers => [qw( 156.154.70.1 156.154.71.1 )], recurse => 1, debug => 0, );
$resolver[5] = Net::DNS::Resolver->new( nameservers => [qw( 199.85.126.10 199.85.127.10 )], recurse => 1, debug => 0, );
$resolver[6] = Net::DNS::Resolver->new( nameservers => [qw( 81.218.119.11 209.88.198.133 )], recurse => 1, debug => 0, );
$resolver[7] = Net::DNS::Resolver->new( nameservers => [qw( 195.46.39.39 195.46.39.40 )], recurse => 1, debug => 0, );
$resolver[8] = Net::DNS::Resolver->new( nameservers => [qw( 216.87.84.211 23.90.4.6 )], recurse => 1, debug => 0, );
$resolver[9] = Net::DNS::Resolver->new( nameservers => [qw( 199.5.157.131 208.71.35.137 )], recurse => 1, debug => 0, );
$resolver[9] = Net::DNS::Resolver->new( nameservers => [qw( 208.76.50.50 208.76.51.51 )], recurse => 1, debug => 0, );
$resolver[10] = Net::DNS::Resolver->new( nameservers => [qw( 89.233.43.71 89.104.194.142 )], recurse => 1, debug => 0, );
$resolver[11] = Net::DNS::Resolver->new( nameservers => [qw( 74.82.42.42 )], recurse => 1, debug => 0, );
$resolver[12] = Net::DNS::Resolver->new( nameservers => [qw( 109.69.8.51 )], recurse => 1, debug => 0, );

say "Please type in how many letters you want to start with: ";
chomp( my $n = <STDIN>);
say "Please type in how many letters you want to test in DNS: ";
chomp( my $limit = <STDIN>);
say "Please type in the top level domain you'd like to brute force [i.e. .com]";
chomp( my $tld = <STDIN>);
say "open domain names will now be logged into /tmp/domlog";
my $domain_word = '';
while( $n <= $limit ){
    my $combinat = new Algorithm::Permute(['a'..'z', '-'], $n);
    while(my @combo = $combinat->next){
        if($count > $throttle){ sleep $sleepthrottle; $count = 0;} #throttle
        $domain_word = '';
        foreach my $domain_char (@combo){
             $domain_word .= $domain_char;
        }
        if( "$domain_word" !~ m/^-.*/ && $domain_word !~ m/.*-$/ ){
            $domain_word .= $tld;
            #say "$domain_word is about to be queried";
            my $query = $resolver[$rescount]->search($domain_word);
            $rescount++;
            if ($rescount > $#resolver){$rescount = 0; $count++;}
            if ($query) {
                #say "$domain_word resolved";
            } else {
                #say "$domain_word did not resolve";
                my $return_output  = grep { $_ =~ m/No\ match/} split(/\n/,  whois($domain_word));
                if($return_output){
                    say "$domain_word is available ";
                    open(LOG, ">>/tmp/domlog") or warn "cant open log $!";
                    print LOG "$domain_word\n";
                    close LOG or warn "cant close log $!";
                    say "$return_output";
                }
            }
        }
    }
    $n++;
}
