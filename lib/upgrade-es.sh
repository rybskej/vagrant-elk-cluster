yum -q -y install screen
yum -q -y install wget

# Install JAVA
# Oracle changed the way to download Java. Hardcoding for jdk-8u151, to be fixed.
JAVA_VERSION_MAJOR=8
JAVA_VERSION_MINOR=151
JAVA_VERSION_BUILD=12
JAVA_DOWNLOAD_HASH=e758a0de34e24606bca991d704f6dcbf
if [ ! -f "/vagrant/jdk-8u151-linux-x64.rpm" ]; then
    wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" \
     http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_DOWNLOAD_HASH}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm \
     -O /vagrant/jdk-8u151-linux-x64.rpm
fi
yum -q -y localinstall /vagrant/jdk-8u151-linux-x64.rpm

# Setting ES version to install
ES_VERSION="6.1.0"
ES_TGZ="elasticsearch-${ES_VERSION}.tar.gz"
ES_DIR="elasticsearch-${ES_VERSION}"
ES_VERSION_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz"
#ES_PLUGIN_INSTALL_CMD="elasticsearch/bin/plugin install"
ES_PLUGIN_INSTALL_CMD="elasticsearch/bin/elasticsearch-plugin install"

# Removing all previous potentially installed version
rm -rf elasticsearch
rm -rf elasticsearch-*

# Downloading the version to install
if [ ! -f "/vagrant/$ES_TGZ" ]; then
    wget -q $ES_VERSION_URL
    tar -zxf $ES_TGZ
    rm -rf $ES_TGZ
else
    tar -zxf /vagrant/$ES_TGZ
fi

# Renaming extracted folder to a generic name to avoid changing ES commands (elasticsearch/bin/...)
mv $ES_DIR elasticsearch

#############
# Plugins

ESPLUGINS=()

ESPLUGINS+=(analysis-icu)
#ESPLUGINS+=(mapper-attachments)

#Monitoring
#ESPLUGINS+=(mobz/elasticsearch-head)
#ESPLUGINS+=(lmenezes/elasticsearch-kopf)
#ESPLUGINS+=(karmi/elasticsearch-paramedic)
#ESPLUGINS+=(royrusso/elasticsearch-HQ)

#ESPLUGINS+=(lang-javascript)

for P in ${ESPLUGINS[*]}
do
	${ES_PLUGIN_INSTALL_CMD} $P
done

chown -R vagrant: elasticsearch

firewall-cmd --zone=public --add-port=9200/tcp --permanent
firewall-cmd --zone=public --add-port=9300/tcp --permanent
systemctl stop firewalld
systemctl start firewalld
