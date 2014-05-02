#! /usr/bin/perl
use Data::Dumper;
use Net::DNS;
use Algorithm::Permute;
use v5.10;
use Math::Combinatorics;
use warnings;
use strict;
use Net::Whois::Raw qw( whois $OMIT_MSG $CHECK_FAIL $CACHE_DIR $CACHE_TIME $USE_CNAMES $TIMEOUT );
    my $OMIT_MSG = 2;
    my $CHECK_FAIL = 2;
    my $CACHE_DIR = "/var/spool/pwhois/";
    my $CACHE_TIME = 24;
    my $USE_CNAMES = 1;
    my $TIMEOUT = 10;
use Getopt::Long;
Getopt::Long::Configure ("bundling");
    my $verbosity = 0;
    my $interactive = 0;
    my $throttle = 1;
    my $sleepthrottle = 10;
    my $startingNumber;
    my $finishingNumber;
    my $tld = '.com';
    GetOptions ("sleepthrottle=i" => \$sleepthrottle,
        "throttle=i"   => \$throttle,
        "finishingNumber=i"   => \$finishingNumber,
        "startingNumber=i"   => \$startingNumber,
        "interactive|i"   => \$interactive,
        "verbose|v+"  => \$verbosity)
    or die("Error in command line arguments\n");
my @resolver;
my $rescount = 0;
my $count = 0;
say "verbosity = $verbosity" unless ($verbosity < 1);
$resolver[0] =  Net::DNS::Resolver->new( nameservers => [qw( 8.8.8.8 8.8.4.4 )], recurse => 1, debug => 0, );
$resolver[1] =  Net::DNS::Resolver->new( nameservers => [qw( 209.244.0.3 209.244.0.4 )], recurse => 1, debug => 0, );
$resolver[2] =  Net::DNS::Resolver->new( nameservers => [qw( 216.146.35.35 216.146.36.36 )], recurse => 1, debug => 0, );
$resolver[3] =  Net::DNS::Resolver->new( nameservers => [qw( 8.26.56.26 8.20.247.20 )], recurse => 1, debug => 0, );
$resolver[4] =  Net::DNS::Resolver->new( nameservers => [qw( 156.154.70.1 156.154.71.1 )], recurse => 1, debug => 0, );
$resolver[5] =  Net::DNS::Resolver->new( nameservers => [qw( 199.85.126.10 199.85.127.10 )], recurse => 1, debug => 0, );
$resolver[6] =  Net::DNS::Resolver->new( nameservers => [qw( 81.218.119.11 209.88.198.133 )], recurse => 1, debug => 0, );
$resolver[7] =  Net::DNS::Resolver->new( nameservers => [qw( 195.46.39.39 195.46.39.40 )], recurse => 1, debug => 0, );
$resolver[8] =  Net::DNS::Resolver->new( nameservers => [qw( 216.87.84.211 23.90.4.6 )], recurse => 1, debug => 0, );
$resolver[9] =  Net::DNS::Resolver->new( nameservers => [qw( 199.5.157.131 208.71.35.137 )], recurse => 1, debug => 0, );
$resolver[9] =  Net::DNS::Resolver->new( nameservers => [qw( 208.76.50.50 208.76.51.51 )], recurse => 1, debug => 0, );
$resolver[10] = Net::DNS::Resolver->new( nameservers => [qw( 89.233.43.71 89.104.194.142 )], recurse => 1, debug => 0, );
$resolver[11] = Net::DNS::Resolver->new( nameservers => [qw( 74.82.42.42 )], recurse => 1, debug => 0, );
$resolver[12] = Net::DNS::Resolver->new( nameservers => [qw( 109.69.8.51 )], recurse => 1, debug => 0, );

unless($finishingNumber && $startingNumber){
 die "usage: read the source or use -i option for interactive mode";
}

if($interactive){
    say "Please type in how many letters you want to start with: ";
    chomp($startingNumber = <STDIN>);
    say "Please type in how many letters you want to test in DNS: ";
    chomp($finishingNumber = <STDIN>);
    say "Please type in the top level domain you'd like to brute force [i.e. .com]";
    chomp($tld = <STDIN>);
}
say "open domain names will now be logged into /tmp/domlog" unless ($verbosity < 2);
my $domain_word = '';
my $n = $startingNumber;
my $limit = $finishingNumber;
while($n <= $limit){
    my $permutation = new Algorithm::Permute(['a'..'z', '-'], $n);
    while(my @permuto = $permutation->next){
        if($count > $throttle){ sleep $sleepthrottle; $count = 0;} #throttle
        $domain_word = '';
        foreach my $domain_char (@permuto){
            $domain_word .= $domain_char;
        }
        if("$domain_word" !~ m/^-.*/ && $domain_word !~ m/.*-$/){
            $domain_word .= $tld;
            say "$domain_word is about to be queried" unless($verbosity < 7);
            my $query = $resolver[$rescount]->search($domain_word);
            $rescount++;
            if ($rescount > $#resolver){$rescount = 0; $count++;}
            if ($query) {
                say "$domain_word resolved" unless($verbosity < 6);
            } else {
                say "$domain_word did not resolve" unless($verbosity < 5);
                #my $whois_output = whois($domain_word); # giving false negatives
                my $whois_output = `whois $domain_word`;
                say $whois_output unless($verbosity < 10);
                my @return_output_positive = grep { $_ =~ m/Registrar:/} split(/\n/,  $whois_output);
                say @return_output_positive unless($verbosity < 9);
                unless(@return_output_positive){
                    my @return_output  = grep { $_ =~ m/No\ match/} split(/\n/,  $whois_output);
                    say @return_output unless($verbosity < 8);
                    if(@return_output){
                        say "$domain_word is available " unless($verbosity < 0);
                        open(LOG, ">>/tmp/domlog") or warn "cant open log $!";
                        print LOG "$domain_word\n";
                        close LOG or warn "cant close log $!";
                        say "@return_output" unless($verbosity < 5);
                    }
                }
            }
        }
    }
    $n++;
}
