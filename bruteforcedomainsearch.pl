#! /usr/bin/perl
use Data::Dumper;
use Net::DNS;
use Algorithm::Permute;
use v5.10;
use Math::Combinatorics;
use warnings;
use strict;
use Carp;
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
        "verbose|v+"  => \$verbosity)
    or croak("Error in command line arguments\n");
my @resolver;
my $rescount = 0;
my $count = 0;
say "verbosity = $verbosity" if ($verbosity > 1);
say "startingNumber = $startingNumber" if ($verbosity > 1);
say "finishingNumber = $finishingNumber" if ($verbosity > 1);
say "throttle = $throttle" if ($verbosity > 1);
say "sleepthrottle = $sleepthrottle" if ($verbosity > 1);
$resolver[0]  =  Net::DNS::Resolver->new( nameservers => [qw( 8.8.8.8 )], recurse => 1, debug => 0, );
$resolver[1]  =  Net::DNS::Resolver->new( nameservers => [qw( 209.244.0.3 )], recurse => 1, debug => 0, );
$resolver[2]  =  Net::DNS::Resolver->new( nameservers => [qw( 216.146.35.35 )], recurse => 1, debug => 0, );
$resolver[3]  =  Net::DNS::Resolver->new( nameservers => [qw( 8.26.56.26 )], recurse => 1, debug => 0, );
$resolver[4]  =  Net::DNS::Resolver->new( nameservers => [qw( 156.154.70.1 )], recurse => 1, debug => 0, );
$resolver[5]  =  Net::DNS::Resolver->new( nameservers => [qw( 199.85.126.10 )], recurse => 1, debug => 0, );
$resolver[6]  =  Net::DNS::Resolver->new( nameservers => [qw( 81.218.119.11 )], recurse => 1, debug => 0, );
$resolver[7]  =  Net::DNS::Resolver->new( nameservers => [qw( 195.46.39.39 )], recurse => 1, debug => 0, );
$resolver[8]  =  Net::DNS::Resolver->new( nameservers => [qw( 64.6.64.6 )], recurse => 1, debug => 0, );
$resolver[9]  =  Net::DNS::Resolver->new( nameservers => [qw( 199.5.157.131 )], recurse => 1, debug => 0, );
#$resolver[9]  =  Net::DNS::Resolver->new( nameservers => [qw( 208.76.50.50 )], recurse => 1, debug => 0, );
$resolver[9]  =  Net::DNS::Resolver->new( nameservers => [qw( 8.8.8.8 )], recurse => 1, debug => 0, );
$resolver[10] =  Net::DNS::Resolver->new( nameservers => [qw( 89.233.43.71 )], recurse => 1, debug => 0, );
$resolver[11] =  Net::DNS::Resolver->new( nameservers => [qw( 74.82.42.42 )], recurse => 1, debug => 0, );
$resolver[12] =  Net::DNS::Resolver->new( nameservers => [qw( 109.69.8.51 )], recurse => 1, debug => 0, );
$resolver[13] =  Net::DNS::Resolver->new( nameservers => [qw( 64.6.65.6 )], recurse => 1, debug => 0, );
$resolver[14] =  Net::DNS::Resolver->new( nameservers => [qw( 84.200.69.80 )], recurse => 1, debug => 0, );
$resolver[15] =  Net::DNS::Resolver->new( nameservers => [qw( 84.200.70.40 )], recurse => 1, debug => 0, );
$resolver[16] =  Net::DNS::Resolver->new( nameservers => [qw( 208.67.222.222 )], recurse => 1, debug => 0, );
$resolver[17] =  Net::DNS::Resolver->new( nameservers => [qw( 208.67.220.220 )], recurse => 1, debug => 0, );
$resolver[18] =  Net::DNS::Resolver->new( nameservers => [qw( 156.154.71.1 )], recurse => 1, debug => 0, );
#$resolver[19] =  Net::DNS::Resolver->new( nameservers => [qw( 96.90.175.167 )], recurse => 1, debug => 0, );
$resolver[19]  =  Net::DNS::Resolver->new( nameservers => [qw( 8.8.8.8 )], recurse => 1, debug => 0, );
$resolver[20] =  Net::DNS::Resolver->new( nameservers => [qw( 193.183.98.154 )], recurse => 1, debug => 0, );
$resolver[21] =  Net::DNS::Resolver->new( nameservers => [qw( 37.235.1.174 )], recurse => 1, debug => 0, );
$resolver[22] =  Net::DNS::Resolver->new( nameservers => [qw( 37.235.1.177 )], recurse => 1, debug => 0, );
$resolver[23] =  Net::DNS::Resolver->new( nameservers => [qw( 198.101.242.72 )], recurse => 1, debug => 0, );
$resolver[24] =  Net::DNS::Resolver->new( nameservers => [qw( 23.253.163.53 )], recurse => 1, debug => 0, );
$resolver[25] =  Net::DNS::Resolver->new( nameservers => [qw( 77.88.8.1 )], recurse => 1, debug => 0, );
$resolver[26] =  Net::DNS::Resolver->new( nameservers => [qw( 77.88.8.8 )], recurse => 1, debug => 0, );
$resolver[27] =  Net::DNS::Resolver->new( nameservers => [qw( 91.239.100.100 )], recurse => 1, debug => 0, );
$resolver[28] =  Net::DNS::Resolver->new( nameservers => [qw( 89.233.43.71 )], recurse => 1, debug => 0, );
$resolver[29] =  Net::DNS::Resolver->new( nameservers => [qw( 74.82.42.42 )], recurse => 1, debug => 0, );
$resolver[30] =  Net::DNS::Resolver->new( nameservers => [qw( 109.69.8.51 )], recurse => 1, debug => 0, );
$resolver[31] =  Net::DNS::Resolver->new( nameservers => [qw( 4.2.2.1 )], recurse => 1, debug => 0, );
$resolver[32] =  Net::DNS::Resolver->new( nameservers => [qw( 4.2.2.2 )], recurse => 1, debug => 0, );
$resolver[33] =  Net::DNS::Resolver->new( nameservers => [qw( 8.8.4.4 )], recurse => 1, debug => 0, );
$resolver[34] =  Net::DNS::Resolver->new( nameservers => [qw( 209.244.0.4 )], recurse => 1, debug => 0, );
$resolver[35] =  Net::DNS::Resolver->new( nameservers => [qw( 216.146.36.36 )], recurse => 1, debug => 0, );
$resolver[36] =  Net::DNS::Resolver->new( nameservers => [qw( 8.20.247.20 )], recurse => 1, debug => 0, );
$resolver[37] =  Net::DNS::Resolver->new( nameservers => [qw( 199.85.127.10 )], recurse => 1, debug => 0, );
$resolver[38] =  Net::DNS::Resolver->new( nameservers => [qw( 209.88.198.133 )], recurse => 1, debug => 0, );
$resolver[39] =  Net::DNS::Resolver->new( nameservers => [qw( 195.46.39.40 )], recurse => 1, debug => 0, );
$resolver[40] =  Net::DNS::Resolver->new( nameservers => [qw( 208.71.35.137 )], recurse => 1, debug => 0, );
$resolver[41] =  Net::DNS::Resolver->new( nameservers => [qw( 208.76.51.51 )], recurse => 1, debug => 0, );
$resolver[42] =  Net::DNS::Resolver->new( nameservers => [qw( 89.104.194.142 )], recurse => 1, debug => 0, );
unless($finishingNumber && $startingNumber){
 croak "usage: read the source or use -i option for interactive mode";
}
if($finishingNumber < $startingNumber){
 croak "you cannot start less than you finish";
}
say "open domain names will now be logged into /tmp/domlog" if ($verbosity > 2);
my $domain_word = '';
my $n = $startingNumber;
say "Entering $n epoch" if($verbosity > 0);
my $limit = $finishingNumber;
while($n <= $limit){
    my $permutation = new Algorithm::Permute(['a'..'z', '-'], $n);
    while(my @permuto = $permutation->next){
        say "count is $count, throttle is $throttle" if($verbosity > 8);
        if($count > $throttle){say "sleepthrottle" if($verbosity > 8); sleep $sleepthrottle; $count = 0;} #throttle
        $domain_word = '';
        foreach my $domain_char (@permuto){
            $domain_word .= $domain_char;
        }
        say "domain word = $domain_word" if($verbosity > 8);
        if("$domain_word" !~ m/^-.*/xm && $domain_word !~ m/.*-$/xm){
            $domain_word .= $tld;
            say "$domain_word is about to be queried by  resolver $rescount which is Dumper(\$resolver[$rescount])" if($verbosity > 7);
            my $query = $resolver[$rescount]->search($domain_word);
            say "$domain_word was queried" if($verbosity > 8);
            $rescount++;
            if ($rescount > $#resolver){$rescount = 0; $count++;}
            if ($query) {
                say "$domain_word resolved" if($verbosity > 6);
            } else {
                say "$domain_word did not resolve" if($verbosity > 5);
                #my $whois_output = whois($domain_word); # giving false negatives
                my $whois_output = `whois $domain_word`;
                say $whois_output if($verbosity > 10);
                my @return_output_positive = grep { $_ =~ m/Registrar:/xm} split(/\n/xm,  $whois_output);
                say @return_output_positive if($verbosity > 9);
                unless(@return_output_positive){
                    my @return_output  = grep { $_ =~ m/No\ match/xm} split(/\n/xm,  $whois_output);
                    say @return_output if($verbosity > 8);
                    if(@return_output){
                        say "$domain_word is available " if($verbosity > 0);
                        open my $LOG, '>>', "/tmp/domlog" or carp "cant open log $!";
                        print $LOG "$domain_word\n";
                        close $LOG or carp "cant close log $!";
                        say "@return_output" if($verbosity > 5);
                    }
                }
            }
        }
    }
    $n++;
    say "Entering $n epoch" if($verbosity > 0);
}
