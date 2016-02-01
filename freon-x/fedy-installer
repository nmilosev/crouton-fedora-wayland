#!/bin/bash

# Script to install Fedy <http://folkswithhats.org/>.
# Copyright (C) 2014  Satyajit sahoo

if [[ ! $(whoami) = "root" ]]; then
    echo "Please run the script as root."
    exit 1
fi


echo "Adding repositories..."
rpm --quiet --query folkswithhats-release || dnf -y --nogpgcheck install http://folkswithhats.org/repo/$(rpm -E %fedora)/RPMS/noarch/folkswithhats-release-1.0.1-1.fc$(rpm -E %fedora).noarch.rpm
rpm --quiet --query rpmfusion-free-release || dnf -y --nogpgcheck install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
rpm --quiet --query rpmfusion-nonfree-release || dnf -y --nogpgcheck install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


echo "Installing fedy..."

dnf -y --nogpgcheck install fedy

# Please report bugs at <http://github.com/folkswithhats/fedy/issues>
# End of the Script
