# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'

=begin

  You can use a specific provider with vagrant's provider flag like so:

  vagrant up --provider=vmware_fusion
  vagrant up --provider=virtualbox

  In order to use the vmware_fusion provider you will need to have a licensed
  copy of vmware fusion installed. You will also need to purchase a vagrant
  vmware seat http://www.vagrantup.com/vmware

  Virtualbox and Vmware each have different base boxes that can be automatically
  downloaded by uncommenting the appropriate server.vm.box_url line below. You
  can read more regarding base boxes at a wiki page you can help correct and
  keep up to date:
  https://github.com/cyberswat/drupal-lamp/wiki/Vagrant-Base-Boxes

=end
data = JSON.parse(File.read("infrastructure/drupal_lamp.json"))

Vagrant.configure("2") do |config|
  # for Vagrant-provided nfs support
  #config.nfs.map_uid = 0
  #config.nfs.map_gid = 0

  config.omnibus.chef_version = '11.16.2'
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = File.dirname(__FILE__) + "/Berksfile"
  config.vm.define :drupaldev do |server|
    server.ssh.forward_agent = true
    server.vm.box = "precise64"
    #server.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-fusion503.box"
    server.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

    server.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"]  = "1024"
    end

    server.vm.provider :virtualbox do |v|
      v.name = "drupal"
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end

    server.vm.hostname = "drupal.local"

    server.vm.network :private_network, ip: "192.168.50.5"

    # For Vagrant-provided synced folders
    # Ensure the second parameter (/assets) is the same as the Default['drupal']['server']['assets']
    # destination in your drupal_lamp.json file
    #server.vm.synced_folder "assets", "/assets", :nfs => false, :owner => "www-data", :group => "www-data"

    server.vm.synced_folder 'assets', '/assets', disabled: true
    # For Vagrant-provided nfs support
    # Ensure the second parameter (/assets) is the same as the Default['drupal']['server']['assets']
    # destination in your drupal_lamp.json file
    #server.vm.synced_folder "assets", "/assets", :nfs => true

    server.vm.provision :chef_solo do |chef|
      chef.log_level = :info
      chef.roles_path = "chef/roles"
      chef.data_bags_path = "chef/data_bags"
      chef.add_role("drupal_lamp")
      chef.json = data
    end
  end
end
