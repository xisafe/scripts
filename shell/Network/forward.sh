
#rinetd
wget http://www.boutell.com/rinetd/http/rinetd.tar.gz
tar xzvf rinetd.tar.gz
cd rinetd
mkdir -p /usr/man/man8
make &&make install
 
#example 
cat /etc/rinetd.conf
192.168.12.3 3389 10.0.99.20 3389
192.168.12.4 3389 10.0.99.21 3389
192.168.12.5 3389 10.0.99.22 3389


