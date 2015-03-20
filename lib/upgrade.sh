# TODO make this work for RH|ubuntu|??
yum -y install screen

# Install JAVA
#yum -y localinstall /vagrant/jdk-7u75-linux-x64.rpm
tar -C /opt -zxf /vagrant/jdk-7u75-linux-x64.tar.gz
# Add code to auto download jdk
cat > /etc/profile.d/java.sh <<THE_END
export JAVA_HOME='/opt/jdk1.7.0_75"
export PATH="$JAVA_HOME/bin:$PATH"
THE_END

# Setting ES version to install
ES_VERSION="elasticsearch-1.4.4"
ES_PLUGIN_INSTALL_CMD="elasticsearch/bin/plugin -install"

# Removing all previous potentially installed version
rm -rf elasticsearch
rm -rf elasticsearch-*

# Downloading the version to install
if [ ! -f "/vagrant/$ES_VERSION.tar.gz" ]; then
    wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_VERSION.tar.gz
    tar -zxf $ES_VERSION.tar.gz
    rm -rf $ES_VERSION.tar.gz
else
    tar -zxf /vagrant/$ES_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing ES commands (elasticsearch/bin/...)
mv $ES_VERSION elasticsearch

# Internal ES plugins
#${ES_PLUGIN_INSTALL_CMD} com.github.kzwang/elasticsearch-image/1.2.0
${ES_PLUGIN_INSTALL_CMD} elasticsearch/elasticsearch-mapper-attachments/2.4.3
#${ES_PLUGIN_INSTALL_CMD} fr.pilato.elasticsearch.river/rssriver/1.3.0
#${ES_PLUGIN_INSTALL_CMD} jdbc --url http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-river-jdbc/1.4.0.9/elasticsearch-river-jdbc-1.4.0.9-plugin.zip
#${ES_PLUGIN_INSTALL_CMD} elasticsearch/elasticsearch-river-rabbitmq/2.4.1
#${ES_PLUGIN_INSTALL_CMD} elasticsearch/elasticsearch-river-twitter/2.4.2
#${ES_PLUGIN_INSTALL_CMD} elasticsearch/elasticsearch-river-wikipedia/2.4.1

# Supervision/Dashboards ES Plugins
${ES_PLUGIN_INSTALL_CMD} mobz/elasticsearch-head
${ES_PLUGIN_INSTALL_CMD} karmi/elasticsearch-paramedic
${ES_PLUGIN_INSTALL_CMD} lukas-vlcek/bigdesk/2.5.0
${ES_PLUGIN_INSTALL_CMD} elasticsearch/marvel/latest
${ES_PLUGIN_INSTALL_CMD} royrusso/elasticsearch-HQ
