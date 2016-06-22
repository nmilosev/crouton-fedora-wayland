crouton-fedora: Crouton version for Fedora
=================================================

This is a modified version of Crouton which installs Fedora onto your Chromebook.
This version isn't nearly as polished as the main version of Crouton with Debian/Ubuntu.
Please don't use this if you aren't familiar with the Crouton project as it is much better
than this version.

Disclaimer
=================================================

All the work here is based on the official Crouton version which can be found here:

https://github.com/dnschneid/crouton

and on this (now a bit old, but still fantastic source) fork for Fedora 20:

https://github.com/divx118/crouton/tree/fedora

I am eternally grateful for these versions, and all the credits should go to their authors.
I merely played with them and modified them a bit.

Useful links
=================================================

My original blog post about crouton-fedora:

http://nmilosev.svbtle.com/crouton-with-fedora-chroot-chromebook

The version 2.0:

http://nmilosev.svbtle.com/crouton-with-fedora-chroot-2-0

The Crouton Fedora chrome app and VNC instructions:

http://nmilosev.svbtle.com/fedora-crouton-connector-chrome-app

Installing VirtualBox:

https://nmilosev.svbtle.com/virtualbox-and-crouton-fedora

Running Docker:

https://nmilosev.svbtle.com/docker-on-crouton-fedora-24

A word of warning
=================================================

If you want maximum stability, please use official Crouton and install Debian or Ubuntu.
This may break with an update or might not even work at all. CLI stuff is pretty reliable,
while the X stuff isn't. Things may break at anytime. This needs a lot more work.
You have been warned.

Installation
=================================================

1. Developer unlock your chromebook
2. Open crosh shell

```
cd ~/Downloads
wget https://github.com/nmilosev/crouton-fedora/archive/master.tar.gz -O crouton-fedora.tar.gz
tar xvf crouton-fedora.tar.gz
sudo sh ./crouton-fedora-master/installer/main.sh -r fedora -t fedora
```

This installs the CLI version. To enter Fedora: ```sudo enter-chroot```

A good practice is to also include a parameter ```-p``` to install this Crouton to the non-default path
since it breaks the official Crouton if you have it installed. For example:

```
sudo mkdir /usr/local/crouton-fedora
sudo sh ./crouton-fedora-master/installer/main.sh -r fedora -t fedora -p /usr/local/crouton-fedora
sudo sh /usr/local/crouton-fedora/bin/enter-chroot
```

Please consult the offical Crouton documentation for this.

With this paramter, you can also install Crouton Fedora onto your sd card or your USB drive. Just please
remember, that performace will be greatly reduced if your SD card/USB drive is slow.

Graphics installation (GNOME/XFCE/anything)
=================================================

Tested only on mine Intel-based chromebook with Freon, please see the ```freon-x/install.sh```
script for more details. It works very well for me but it might not work for you. If it doesn't work,
you can always run a local VNC server (check my blog in the useful links section) but it is much slower
than the real deal.

From the chroot (as fedora user):

```
sudo sh /home/fedora/Downloads/crouton-fedora-master/freon-x/install.sh
```

Check if the script outputed errors, and try to fix them.

Run ```sudo freonx``` to start the installed DE/WM.

Top tip: run ```sudo enter-chroot sudo freonx``` to go from crosh to Fedora desktop directly.

Available are: GNOME, KDE, Xfce, LXDE, MATE, Cinnamon and they all work. You can also install a WM (like i3 or others) only. To install other DE's modify the variables at the top of ```install.sh``` script.

Things that are working for me:

- video
- audio
- mouse and keyboard
- bluetooth/wifi
- suspend-resume
- switching back to chromeOS with a keyboard shortcut
- switching back to Fedora with a keyboard shortcut
- 3D hardware acceleration

Broken stuff:

- you have to run X as root (fixed now! Was X server security related issue, see below)
- you have to manually setup keybindings for going back to ChromeOS ```/bin/croutoncycle cros``` on CTRL+ALT+SHIFT+F1
- GNOME isn't very happy to run without systemd
- switching can sometimes be "wonky"

If you don't have Freon, you should be able to connect to the X server started by ChromeOS
with the included ```host-X11``` command from Crouton.

Tip: Use Fedy to install stuff. It works great with Fedora.

FAQ:
---

**How do I switch back?**

Type ```croutoncycle cros``` to the terminal. Tip: create a keyboard shortcut (CTRL+ALT+SHIFT+F1) for this
from GNOME settings. You can logout to exit Fedora and return to ChromeOS.

**How do I switch to Fedora?**

Type ```croutoncycle :0``` to another terminal or press CTRL+ALT+SHIFT+F2.

**How to run X as non root?**

You can run X as non root, but there are some issues - nothing big. I will continue to try to fix this in the future.

- Needed changes:

```
cat > /etc/X11/Xwrapper.config <<- EOM
allowed_users=anybody
needs_root_rights=yes
EOM # this fixes the "Console users aren't allowed to run X"
sudo chown 1000:1000 /tmp/ -R # this fixes croutonfreon errors for display management
cp /usr/libexec/Xorg /usr/bin/ # don't ask, it just works like that, fixes can't find /dev/tty0 error, could be Fedora specific
```

This is now all done by default! If you need to run X as root, use ```sudo freonx```. Switching is broken when running as normal user for now. When you logout the screen will be black. To get back to ChromeOS press CTRL+ALT+F2 and then CTRL+ALT+F1. I will try to fix this.

**How much space do I need?**

- ~3GB for the GNOME + CLI installation.
- ~2GB for the XFCE + CLI installation.
- ~500MB for CLI only.

**How to install other DE's?**

Modify ```install.sh``` script.

**My download is slow or not working...**

Modify the ```defaults``` file in ```installater/fedora``` folder. You can find mirrors on the
fedora mirror list site.

**What about Wine?**

Wine works fine. I've sucessfully installed Photoshop CS6 through the PlayOnLinux Wine front-end.

**Virtual Box/Docker?**

Both work. Check the useful links section.

**Architecture?**

You can install an i686 chroot onto a x86_64 Chromebook. Specify ```-a i386``` to the installer. This way it will take
much less space, and you really don't lose anything. You will also need to run dnf with [BROKEN AT THE MOMENT DNF DOESN'T RESPECT]

How does it look like?
---
![Imgur](http://i.imgur.com/J9RzbVo.jpg)

How does it perform?
---

Extremely well. You can't tell it is running inside chroot as with the original Crouton.

License
-------
crouton (including this eloquently-written README) is copyright &copy; 2016 The
crouton Authors. All rights reserved. Use of the source code included here is
governed by a BSD-style license that can be found in the LICENSE file in the
source tree.

Fedora is property of Red Hat Corporation.

I'm merely a mortal, if anybody is offended by this code, please inform me, and it
will be taken down immediately.
