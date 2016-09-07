yum -q -y install screen
yum -q -y install wget

# Install JAVA
if [ ! -f "/vagrant/jdk-8u101-linux-x64.rpm" ]; then
  wget -q "http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.rpm" /vagrant/.
fi
yum -q -y localinstall /vagrant/jdk-8u101-linux-x64.rpm

# Setting ES version to install
ES_VERSION="elasticsearch-2.3.3"
ES_VERSION_URL="https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.3/${ES_VERSION}.tar.gz"
ES_PLUGIN_INSTALL_CMD="elasticsearch/bin/plugin install"

# Removing all previous potentially installed version
rm -rf elasticsearch
rm -rf elasticsearch-*

# Downloading the version to install
if [ ! -f "/vagrant/$ES_VERSION.tar.gz" ]; then
    wget -q $ES_VERSION_URL
    tar -zxf $ES_VERSION.tar.gz
    rm -rf $ES_VERSION.tar.gz
else
    tar -zxf /vagrant/$ES_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing ES commands (elasticsearch/bin/...)
mv $ES_VERSION elasticsearch

#############
# Plugins

ESPLUGINS=()

#Analysis plugins
ESPLUGINS+=(analysis-icu)
ESPLUGINS+=(analysis-kuromoji)
ESPLUGINS+=(analysis-smartcn)
ESPLUGINS+=(analysis-stempel)

#Monitoring
ESPLUGINS+=(mobz/elasticsearch-head/)
ESPLUGINS+=(polyfractal/elasticsearch-inquisitor)
#ESPLUGINS+=(com.automattic/elasticsearch-statsd/2.3.3.0)
ESPLUGINS+=(xyu/elasticsearch-whatson/0.1.4)

#Extensions
ESPLUGINS+=(http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-langdetect/2.3.3.0/elasticsearch-langdetect-2.3.3.0-plugin.zip)
ESPLUGINS+=(delete-by-query)
#ESPLUGINS+=(graph)
ESPLUGINS+=(lang-javascript)
#ESPLUGINS+=(license)

for P in ${ESPLUGINS[*]}
do
	${ES_PLUGIN_INSTALL_CMD} $P
done

chown -R vagrant: elasticsearch

firewall-cmd --zone=public --add-port=9200/tcp --permanent
firewall-cmd --zone=public --add-port=9300/tcp --permanent
systemctl stop firewalld
systemctl start firewalld
