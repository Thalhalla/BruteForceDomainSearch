FROM debian:jessie
ENV BRUTEFORCEDOMAINSEARCH 20170120
ENV LANG en_US.UTF-8

USER root
RUN DEBIAN_FRONTEND=noninteractive \
apt-get -qq update && apt-get -qqy dist-upgrade && \
apt-get -qqy --no-install-recommends install \
build-essential cpanminus perl locales \
whois wget curl && \
useradd brute && \
echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen && \
echo 'en_US ISO-8859-1'>>/etc/locale.gen && \
echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen && \
locale-gen && \
apt-get -y autoremove && \
apt-get clean && \
cpanm lib::xi && \
cpanm Data::Dumper && \
cpanm Parallel::ForkManager && \
cpanm Net::DNS && \
cpanm Algorithm::Permute && \
cpanm Math::Combinatorics && \
cpanm Carp && \
cpanm Net::Whois::Raw && \
cpanm Getopt::Long && \
rm -Rf /var/lib/apt/lists/*

COPY bruteforcedomainsearch.pl /home/brute/
COPY Makefile /home/brute/
COPY run.sh /home/brute/

USER brute
WORKDIR /home/brute

ENTRYPOINT [ "/home/brute/run.sh" ]
CMD [ "full" ]
