# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'erb'

Vagrant::Config.run do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-server-cloud12.04-x86"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :hostonly, "192.168.3.100"

  # Check for version mismatch of Guest Additions, but do not install anything.
  config.vbguest.no_install = true

  # Enable provisioning through a shell script.
  config.vm.provision :shell do |shell|
    directory    = File.dirname(__FILE__) + '/scripts/vagrant/'
    shell.inline = ERB.new(
      "<% def import(file); File.read('#{directory}' + file); end %>" +
      File.read("#{directory}provision")
    ).result
  end
end
