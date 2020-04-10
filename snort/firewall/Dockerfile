FROM debian:buster

RUN apt-get update

RUN apt-get install -y gcc g++ make libpcre3-dev zlib1g-dev libluajit-5.1-dev libpcap-dev openssl libssl-dev libnghttp2-dev libdumbnet-dev bison flex libdnet

RUN mkdir /snort_src

COPY daq-2.0.6.tar.gz /snort_src/
COPY libdnet-1.11.tar.gz /snort_src/
COPY snort-2.9.15.1.tar.gz /snort_src/

RUN cd /snort_src && tar xzvf daq-2.0.6.tar.gz && cd daq-2.0.6 && ./configure && make && make install
RUN cd /snort_src && tar xzvf libdnet-1.11.tar.gz && cd libdnet-1.11 && ./configure && make && make install
RUN cd /usr/lib/ && ln -s /usr/local/lib/libdnet.1.0.1 libdnet.1
RUN cd /snort_src && tar xzvf snort-2.9.15.1.tar.gz && cd snort-2.9.15.1 && ./configure --enable-sourcefire && make && make install

RUN mkdir -p /etc/snort/rules
RUN cd /snort_src && cd snort-2.9.15.1 && cp etc/*.conf* /etc/snort
RUN echo 'alert icmp any any -> $HOME_NET any (msg:"ICMP test"; sid:10000001; rev:001;)'>/etc/snort/rules/local.rules

