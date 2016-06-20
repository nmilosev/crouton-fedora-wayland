#This script installs DE to Fedora Crouton
#Author: Nemanja Milosevic nmilosev.svbtle.com

#scriptdir
dir=$(dirname $0)

#change your DE here, for example for XFCE:
#groupname="XFCE Desktop"
#sessionname="xfce4-session"

groupname="Fedora Workstation"
sessionname="gnome-session"

#install intel and touchpad driver, you can subsitute these with what you need
sudo dnf install xorg-x11-drv-intel* xorg-x11-drv-synaptics* -y

#install GNOME group with DNF, you can substitute this with a DE of your choice
#but don't forget to modify the xinitrc file
sudo dnf groupinstall "$groupname" -y

#install croutonfreon a.k.a. 'black magic from the dark side'
sudo cp $dir/croutonfreon.so /usr/local/lib/croutonfreon.so

#create shortcut for launching x with croutonpowerd which will prevent chromebook from sleeping
#if you dont have freon and still have X server running (lucky bastard) you should be able to run x with dbus-X11

sudo cp $dir/freonx.sh /usr/local/bin/freonx
sudo chmod +x /usr/local/bin/freonx

sudo cp $dir/freonx-root.sh /usr/local/bin/freonx-root
sudo chmod +x /usr/local/bin/freonx-root

#allow root to use host-dbus
sudo ln -s /usr/local/bin/host-dbus /bin/host-dbus

#create xinitrc and give it to root
cat > /home/fedora/.xinitrc <<- EOM
exec $sessionname
EOM

#fix Xwrapper.config
cat > /etc/X11/Xwrapper.config <<- EOM
allowed_users=anybody
needs_root_rights=yes
EOM

sudo su -c 'cp /home/fedora/.xinitrc /root/.xinitrc'
sudo su -c 'cp /home/fedora/.bash_profile /home/fedora/.bashrc'

#fix screen tear with xorg.conf
#only for intel, you might have to modify this
sudo cp $dir/xorg.conf /etc/X11/xorg.conf

#Fedora fix for X
cp /usr/libexec/Xorg /usr/bin/

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
echo 'Launch with the command freonx'
echo 'Dont forget to set a keyboard shortcut for "croutoncycle cros" for returning to ChromeOS'
echo 'Sound works you can control volume with command volume'
echo 'You can control brightness with command brightness'
echo 'You can enable tap to click from the DE settings!'
echo 'To exit, just logout'
echo 'Have fun, and send patches!'