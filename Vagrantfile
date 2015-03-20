# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'
require_relative 'lib/elasticsearch-module.rb'
require_relative 'lib/elasticsearch-script.rb'

utils = Vagrant::ElastiSearchCluster::Util.new

Vagrant.configure("2") do |config|

  utils.manage_and_print_config
  config.vm.network "forwarded_port", guest: 9200, host: 9200, auto_correct: true
  config.vm.network "forwarded_port", guest: 9300, host: 9300, auto_correct: true

  nodes_number = utils.get_cluster_info 'cluster_count'
  nodes_number = nodes_number.to_i

  cluster_ram = utils.get_cluster_info 'cluster_ram'
  cluster_ram = cluster_ram.to_i

  cluster_cpu = utils.get_cluster_info 'cluster_cpu'

  config.vm.box = 'hashicorp/trusty64'

  config.vm.provider 'virtualbox' do |vbox|
    #config.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :mount_options => ['dmode=777', 'fmode=777']
    config.vm.box = 'ypereirareis/debian-elasticsearch-amd64'
    vbox.customize ['modifyvm', :id, '--memory', cluster_ram]
    vbox.customize ['modifyvm', :id, '--cpus', cluster_cpu]
  end
  config.vm.provider "parallels" do |v|
        config.vm.box = "parallels/centos-7.0"
        #v.update_guest_tools = true
        v.optimize_power_consumption = false
        v.memory = cluster_ram
        v.cpus = cluster_cpu
  end
  #TODO add vmware customization

  (1..nodes_number).each do |index|
      name = utils.get_vm_name index
      node_name = utils.get_node_name index
      ip = utils.get_vm_ip index
      primary = (index.eql? 1)

      utils.build_config index

      config.vm.define :"#{name}", primary: primary do |node|
          node.vm.hostname = "#{node_name}.es.dev"
          node.vm.network 'private_network', ip: ip, auto_config: true
          node.vm.provision 'shell', path: './lib/upgrade.sh'
          node.vm.provision 'shell', inline: @node_start_inline_script % [name, node_name, ip],
              run: 'always'
      end
  end
  utils.logger.info "----------------------------------------------------------"
end
