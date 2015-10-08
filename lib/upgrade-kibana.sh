yum -q -y install screen

# Setting ES version to install
KIBANA_VERSION="kibana-4.1.2-linux-x64"

# Removing all previous potentially installed version
rm -rf kibana
rm -rf kibana-*

# Downloading the version to install
if [ ! -f "/vagrant/$KIBANA_VERSION.tar.gz" ]; then
    wget -q https://download.elastic.co/kibana/kibana/${KIBANA_VERSION}.tar.gz
    tar -zxf $KIBANA_VERSION.tar.gz
    rm -rf $KIBANA_VERSION.tar.gz
else
    tar -zxf /vagrant/$KIBANA_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing commands 
mv $KIBANA_VERSION kibana

