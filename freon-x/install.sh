#This script installs GNOME to Fedora Crouton
#Author: Nemanja Milosevic nmilosev.svbtle.com

#scriptdir
dir=$(dirname $0)

#install intel and touchpad driver, you can subsitute these with what you need
sudo dnf install xorg-x11-drv-intel* xorg-x11-drv-synaptics* -y

#install GNOME group with DNF, you can substitute this with a DE of your choice
#but don't forget to modify the xinitrc file
#gnome-terminal is broken, and installing firefox on chromeos feels dirty so we install terminator and epiphany
sudo dnf groupinstall "Fedora Workstation" --exclude=gnome-terminal,firefox -y
sudo dnf install terminator epiphany -y

#install croutonfreon a.k.a. 'black magic from the dark side'
sudo cp $dir/croutonfreon.so /usr/local/lib/croutonfreon.so

#create shortcut for launching x with croutonpowerd which will prevent chromebook from sleeping
#if you dont have freon and still have X server running (lucky bastard) you should be able to run x with
cat > $dir/freonx.sh <<- EOM
#!/bin/sh
#start trigger service:
sudo su -c 'croutontriggerd &'
#startx:
sudo DBUS_SYSTEM_BUS_ADDRESS='unix:path=/var/host/dbus/system_bus_socket' LD_PRELOAD='/usr/local/lib/croutonfreon.so' XARGS='-nolisten tcp' croutonpowerd -i startx :1
EOM

sudo cp $dir/freonx.sh /usr/local/bin/freonx
sudo chmod +x /usr/local/bin/freonx

#allow root to use host-dbus
sudo ln -s /usr/local/bin/host-dbus /bin/host-dbus

#create xinitrc and give it to root
#if you didn't install GNOME change this, ex. 'exec startxfce4' for xfce
cat > /home/fedora/.xinitrc <<- EOM
exec gnome-session
EOM

sudo su -c 'cp /home/fedora/.xinitrc /root/.xinitrc'

#fix screen tear with xorg.conf
#only for intel, you might have to modify this
sudo cp $dir/xorg.conf /etc/X11/xorg.conf

#fix croutoncycle for root
sudo ln -s /usr/local/bin/croutoncycle /bin/croutoncycle

#allow brightness
sudo ln -s /usr/local/bin/brightness /bin/brightness

#allow volume
sudo ln -s /usr/local/bin/volume /bin/volume

#allow powerd
sudo ln -s /usr/local/bin/croutonpowerd /bin/croutonpowerd

#allow powerd
sudo ln -s /usr/local/bin/croutontriggerd /bin/croutontriggerd

#allow powerd
sudo ln -s /usr/local/bin/crouton-noroot /bin/crouton-noroot

#tips
echo
echo 'Done'
echo 'Launch GNOME with the command freonx'
echo 'Dont forget to set a keyboard shortcut for "croutoncycle cros" for returning to ChromeOS'
echo 'Sound works you can control volume with command volume'
echo 'You can control brightness with command brightness'
echo 'You can enable tap to click from the GNOME settings!'
echo 'To exit GNOME just logout'
echo 'Have fun, and send patches!'