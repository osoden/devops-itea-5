#!/bin/sh -eux

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso|virtualbox-ovf)
    mkdir -p /media/cdrom > /dev/null
    VERSION=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_$VERSION.iso /media/cdrom > /dev/null
    sh /media/cdrom/VBoxLinuxAdditions.run > /dev/null
    umount /media/cdrom/ > /dev/null
    rmdir /media/cdrom > /dev/null
    rm -f /home/vagrant/*.iso > /dev/null
    ;;

parallels-iso|parallels-pvm)
    mkdir -p /media/cdrom > /dev/null
    mount -o loop /home/vagrant/prl-tools-lin.iso /media/cdrom > /dev/null
    /media/cdrom/install --install-unattended
    umount /media/cdrom > /dev/null
    rmdir /media/cdrom > /dev/null
    rm -f /home/vagrant/prl-tools-lin.iso > /dev/null
    ;;

esac
