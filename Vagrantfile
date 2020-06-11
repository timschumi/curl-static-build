# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "x64" do |x64|
    x64.vm.box = "generic/debian9"
  end

  config.vm.define "x86" do |x86|
    x86.vm.box = "generic-x32/debian9"
  end

  config.vm.hostname = "curl-build"
  config.vm.synced_folder ".", "/vagrant", nfs_version: 4

  config.vm.provision "shell", inline: <<-SHELL
    apt update && apt -y upgrade

    apt -y install build-essential
  SHELL
end
