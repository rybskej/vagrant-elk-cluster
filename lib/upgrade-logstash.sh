yum -q -y install screen

# Install JAVA
yum -q -y localinstall /vagrant/jdk-8u65-linux-x64.rpm


# Setting ES version to install
LOGSTASH_VERSION="logstash-2.0.0"

# Removing all previous potentially installed version
rm -rf logstash
rm -rf logstash-*

# Downloading the version to install
if [ ! -f "/vagrant/$LOGSTASH_VERSION.tar.gz" ]; then
    wget -q https://download.elastic.co/logstash/logstash/${LOGSTASH_VERSION}.tar.gz
    tar -zxf $LOGSTASH_VERSION.tar.gz
    rm -rf $LOGSTASH_VERSION.tar.gz
else
    tar -zxf /vagrant/$LOGSTASH_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing commands 
mv $LOGSTASH_VERSION logstash

chown -R vagrant: logstash

firewall-cmd --zone=public --add-port=5514/tcp --permanent
firewall-cmd --zone=public --add-port=5514/udp --permanent
systemctl stop firewalld
systemctl start firewalld
