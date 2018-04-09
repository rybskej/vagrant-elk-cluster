yum -q -y install screen
yum -q -y install wget

# Install JAVA
# Oracle changed the way to download Java. Hardcoding for jdk-XuYYY, to be fixed.
JAVA_VERSION_MAJOR=8
JAVA_VERSION_MINOR=161
JAVA_VERSION_BUILD=12
JAVA_DOWNLOAD_HASH=2f38c3b165be4555a1fa6e98c45e0808
if [ ! -f "/vagrant/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm" ]; then
    wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" \
     http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_DOWNLOAD_HASH}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm \
     -O /vagrant/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm
fi
yum -q -y localinstall /vagrant/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm

# Setting ES version to install
LOGSTASH_VERSION="logstash-6.2.3"

# Removing all previous potentially installed version
rm -rf logstash
rm -rf logstash-*

# Downloading the version to install
if [ ! -f "/vagrant/$LOGSTASH_VERSION.tar.gz" ]; then
    wget -q https://artifacts.elastic.co/downloads/logstash/${LOGSTASH_VERSION}.tar.gz
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
