vagrant-elasticsearch-cluster
=============================

Create an ElasticSearch cluster with a single bash command :

```
vagrant up
```
<div style='color:red'>**Read Pre Requisites below**</div>


**Programs, plugins, libs and versions information**

| Program, plugin, lib              | Version     | How to use it                             |
| --------------------------------- | ----------- | ----------------------------------------- |
| ElasticSearch                     | 1.5.0       | [http://www.elasticsearch.org/guide/](http://www.elasticsearch.org/guide/) |
| Java (oracle)              | 1.7.0_75    |                                           |
| elasticsearch-mapper-attachments  | latest       | [https://github.com/elasticsearch/elasticsearch-mapper-attachments](https://github.com/elasticsearch/elasticsearch-mapper-attachments) |

This plugins are just installed through the `bin/plugin -i` command. You must configure everything else.

**Cluster default configuration**

| Configuration              |  Value(s)                                            |
| -------------------------- | ---------------------------------------------------- |
| Cluster name               |es-dev-cluster                        |
| Nodes names                | thor, zeus, isis, baal, shifu                        |
| VM names                   | vm1, vm2, vm3, vm4, vm5                              |
| Default cluster network IP | 10.0.0.0                                             |


1.Installation and requirements
--

**Must have on your local machine**

* VirtualBox (last version) OR VMWare desktop|fusion OR parallels
* Respective provider plugins for vmware or parallels
* Vagrant (>=1.5)
* cUrl (or another REST client to talk to ES)

**Clone this repository**

git clone git@github.com:bhaskar_vk/vagrant-elasticsearch-cluster.git

**WARNING**

You'll need enough RAM to run VMs in your cluster.
Each new VM launched within your cluster will have 1024M of RAM allocated.
You can change this configuration in the Vagrantfile once cloned.

2.How to run a new ElasticSearch cluster
--

**Important**

The maximum number VMs running in the cluster is 5.
Indeed, it is possible to run much more than 5, but it's not really needed for a test environment cluster,
and the RAM needed would be much more important.
If you still want to use more than 5 VMs,
you will have to add/edit your own configuration files in the [conf](conf) directory.

By default 3 VMs are started but you can increase (max 5) or decrease (min 1) as you see fit in `lib/elasticsearch-module.rb`

**Pre Requisite**

*	Download JDK 7 64bit RPM from [http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html](Oracle) 
*	Download elasticsearch-1.5.0.tar.gz from [https://www.elastic.co/downloads/elasticsearch](elastic)
*	Place both files at the root of this repo.
*	This is one time step
*	If you need to upgrade ES or JDK download respective versions and change `lib/upgrade.sh` and re-run provisioning.

**Run the cluster**

Simply go in the cloned directory (vagrant-elasticsearch-cluster by default).
Execute this command :

```
vagrant up
```

By default, this command will boot 5 VMs, with `My amazing ES cluster` name, `1024M` of RAM and `1` virtual CPU for each node and this network ip address `10.0.0.0`.

You can change the cluster size with the `CLUSTER_COUNT` variable:

```
CLUSTER_COUNT=3 vagrant up
```

You can change the cluster name with the `CLUSTER_NAME` variable:

```
CLUSTER_NAME='My awesome cluster' vagrant up
```

You can change the cluster RAM used for each node with the `CLUSTER_RAM` variable:

```
CLUSTER_RAM=1024 vagrant up
```

You can change the cluster CPU used for each node with the `CLUSTER_CPU` variable:

```
CLUSTER_CPU=2 vagrant up
```

You can change the cluster network IP address with the `CLUSTER_IP_PATTERN` variable:

```
CLUSTER_IP_PATTERN='172.16.15.%d' vagrant up
```

Providing the `CLUSTER_NAME`, `CLUSTER_COUNT`, `CLUSTER_RAM`, `CLUSTER_CPU`, `CLUSTER_IP_PATTERN` variables is only required when you first start the cluster.
Vagrant will save/cache these values so you can run other commands without repeating yourself.

Of course you can use all these variables at the same time :

```
$ CLUSTER_NAME='My awesome search engine' CLUSTER_IP_PATTERN='172.16.25.%d' CLUSTER_COUNT=3 CLUSTER_RAM=512 CLUSTER_CPU=2 vagrant status
----------------------------------------------------------
          Your ES cluster configurations
----------------------------------------------------------
Cluster Name: My awesome search engine
Cluster size: 3
Cluster network IP: 172.16.25.0
Cluster RAM (for each node): 512
----------------------------------------------------------
----------------------------------------------------------
Current machine states:

vm1                       not created (virtualbox)
vm2                       not created (virtualbox)
vm3                       not created (virtualbox)

...
```

The names of the VMs will follow the following pattern: `vm[0-9]+`.
The trailing number represents the index of the VM, starting at 1.

ElasticSearch instance is started during provisioning of the VM.
The command is launched into a new screen as root user inside the vagrant.

Once the cluster is launched (please wait a few seconds) go to : [http://10.0.0.11:9200](http://10.0.0.11:9200)

Plugins URLs (replace IP if you changed it with `CLUSTER_IP_PATTERN` var) :

* [http://10.0.0.11:9200/_plugin/marvel](http://10.0.0.11:9200/_plugin/kopf)
* [http://10.0.0.11:9200/_plugin/paramedic/](http://10.0.0.11:9200/_plugin/paramedic/)
* [http://10.0.0.11:9200/_plugin/head/](http://10.0.0.11:9200/_plugin/head/)
* [http://10.0.0.11:9200/_plugin/bigdesk](http://10.0.0.11:9200/_plugin/bigdesk)
* [http://10.0.0.11:9200/_plugin/HQ/](http://10.0.0.11:9200/_plugin/HQ/)

The default configuration (HTTP enabled for all nodes) allows you to use any of your VM IPs.
If one (or more) of your nodes fails, try with another IP to see what happened.

By default the cluster nodes have an IP following the pattern "10.0.0.%d" as you can see in [Vagrantfile](Vagrantfile).

But you can change it using an ENV var :

```
CLUSTER_COUNT=2 CLUSTER_IP_PATTERN='172.16.10.%d' vagrant up
```

* This command will start 2 ES instances with IPs like : 172.16.10.11, 172.16.10.12.
* :warning: Before that, you must verify that config files (conf/vm*) do not exist or delete them.
* Indeed, this files need to be re-written.

You will see this kind of shell :

```
$ CLUSTER_COUNT=2 CLUSTER_IP_PATTERN='172.16.10.%d' vagrant up
Cluster size: 2
Cluster IP: 172.16.10.0
Bringing machine 'vm1' up with 'virtualbox' provider...
Bringing machine 'vm2' up with 'virtualbox' provider...

```

And you now access to nodes like that : [http://172.16.10.11:9200](http://172.16.10.11:9200)

**Stop the cluster**

```
vagrant halt
```

This will stop the whole cluster. If you want to only stop one VM, you can use:

```
vagrant halt vm2
```

This will stop the `vm2` instance.

**Destroy the cluster**

```
vagrant destroy
rm -rf conf/elasticsearch-vm* log/* data/* 
```

This will stop the whole cluster. If you want to only stop one VM, you can use:

```
vagrant destroy vm2
```

:warning: If you destroy a VM, I suggest you to destroy all the cluster to be sure to have the same ES version in all of your nodes.

**Managing ElasticSearch instances**

Each VM has its own ElasticSearch instance running in a `screen` session named `elastic`.
Once connected to the VM, you can manage this instance with the following commands:

* `(sudo) node-start`: starts the ES instance
* `(sudo) node-stop`: stops the ES instance
* `(sudo) node-restart`: restarts the ES instance
* `(sudo) node-status`: displays ES instance's status
* `(sudo) node-attach`: bring you to the screen session hosting the ES instance. Use `^Ad` to detach.

You should be brought to the screen session hosting ElasticSearch and see its log.

The first launch of ES instance is done by vagrant provisioning.
So you should prepend `sudo` for each command above.
But you have the possibility to start an ES instance as 'vagrant' user from the VM.

```
vagrant ssh vmX
sudo node-stop
node-start
```

This chain of commands will log you into a chosen VM,
will stop the ES 'root-user' instance and will start a 'vagrant-user' ES instance.

3.Default Directories
By default the `data`, `logs` and `config` directories live outside of the VMs on the host, this way you can destroy and rebuild VMs as much as you like without losing your data. You can also upgrade Elasticsearch and not lose data.

4.Configure your cluster
--

If you need or want to change the default working configuration of your cluster,
you can do it adding/editing elasticsearch.yml files in conf/vmX/elasticsearch.yml.
Each node configuration is shared with VM thanks to this "conf" directory.

By default, this configuration files are **auto-generated** by Vagrant when running the cluster for the first time.
In this case, default values listed at the top of this page are used.


5.ElasticSearch plugins inside the base box
--

* elasticsearch-head - [https://github.com/mobz/elasticsearch-head](https://github.com/mobz/elasticsearch-head)
* elasticsearch-paramedic - [https://github.com/karmi/elasticsearch-paramedic](https://github.com/karmi/elasticsearch-paramedic)
* BigDesk - [https://github.com/lukas-vlcek/bigdesk](https://github.com/lukas-vlcek/bigdesk)
* Kopf - [https://github.com/lmenezes/elasticsearch-kopf](https://github.com/lmenezes/elasticsearch-kopf)
* ElasticsearchHQ - [http://www.elastichq.org/](http://www.elastichq.org/)


6.Working with your cluster
--

**Create a "subscriptions" index with 5 shards and 2 replicas**

```
curl -XPUT 'http://10.0.0.11:9200/subscriptions/' -d '{
    "settings" : {
        "number_of_shards" : 5,
        "number_of_replicas" : 2
    }
}'
```

**Index a "subscription" document inside the "subscriptions" index**

```
curl -XPUT 'http://10.0.0.11:9200/subscriptions/subscription/1' -d '{
    "user" : "ypereirareis",
    "post_date" : "2014-03-26T14:12:12",
    "message" : "Trying out vagrant elasticsearch cluster"
}'
```

You can now perform any action/request authorized by elasticsearch API (index, get, delete, bulk,...)

7.Vagrant
--

You can use every vagrant command to manage your cluster and VMs.
This project is simply made to launch a working ES cluster with a single command, using vagrant/virtualbox virtual machines.

Use it to test every configuration/queries you want (split brain, unicast, recovery, indexing, sharding)

8.Important
--

Do forks, PR, and MRs !!!!

9.TODO
--

* Add configuration to create a true cluster with dedicated master, client and data nodes.
