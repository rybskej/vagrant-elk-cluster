yum -q -y install screen
yum -q -y install wget

# Install JAVA
if [ ! -f "/vagrant/jdk-8u101-linux-x64.rpm" ]; then
    curl --silent -L --cookie "oraclelicense=accept-securebackup-cookie" \
      http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.rpm \
      -o /vagrant/jdk-8u101-linux-x64.rpm --retry 999 --retry-max-time 0 -C -
fi
yum -q -y localinstall /vagrant/jdk-8u101-linux-x64.rpm

# Setting ES version to install
ES_VERSION="2.4.1"
ES_TGZ="elasticsearch-${ES_VERSION}.tar.gz"
ES_DIR="elasticsearch-${ES_VERSION}"
ES_VERSION_URL="https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ES_VERSION}/${ES_TGZ}"
ES_PLUGIN_INSTALL_CMD="elasticsearch/bin/plugin install"

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
ESPLUGINS+=(mobz/elasticsearch-head)
ESPLUGINS+=(lmenezes/elasticsearch-kopf)
ESPLUGINS+=(karmi/elasticsearch-paramedic)
ESPLUGINS+=(royrusso/elasticsearch-HQ)

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
