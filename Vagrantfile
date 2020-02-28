# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/arch"

  config.vm.synced_folder ".", "/vagrant", nfs_version: 4

  config.vm.provision "shell", inline: <<-SHELL
    echo "[multilib]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

    pacman -Syu --noconfirm
    pacman -S base-devel git inetutils python2 python2-configparser multilib-devel zlib lib32-zlib openssl lib32-openssl --needed --noconfirm

    # python2 -> python
    ln -s /usr/bin/python2 /usr/bin/python

    # Set a nicer hostname
    hostname curl-build
  SHELL
end
