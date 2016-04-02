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
sudo sh ./crouton-fedora-master/installer/main.sh -r fedora23 -t fedora
```

This install the CLI version. To enter Fedora: ```sudo enter-chroot```

A good practice is to also include a parameter ```-p``` to install this Crouton to the non-default path
since it breaks the official Crouton if you have it installed. For example:

```
sudo mkdir /mnt/stateful_partition/crouton-fedora
sudo sh ./crouton-fedora/installer/main.sh -r fedora23 -t fedora -p /mnt/stateful_partition/crouton-fedora
```

Please consult the offical Crouton documentation for this.

With this paramter, you can also install Crouton Fedora onto your sd card or your USB drive. Just please
remember, that performace will be greatly reduced if your SD card/USB drive is slow.

Fedora 24 Alpha
=================================================

You can now try the new Fedora 24 Alpha. Be aware that it is less stable than 23.

```
cd ~/Downloads
wget http://bit.ly/1qo0vFv -O crouton-fedora24.tar.gz
tar xvf crouton-fedora24.tar.gz
sudo sh ./crouton-fedora-master/installer/main.sh -r fedora24 -t fedora
```

This installs Fedora 24 Minimal install. It takes a bit longer than the 23 installation.

You can install DE as described below. XFCE is default now.

Have fun!

Graphics installation (GNOME)
=================================================

Tested only on mine Intel-based chromebook with Freon, please see the ```freon-x/install.sh```
script for more details. It works very well for me but it might not work for you. If it doesn't work,
you can always run a local VNC server (check my blog in the useful links section) but it is much slower
than the real deal.

From the chroot:

```
sudo sh ~/Downloads/crouton-fedora/freon-x/install.sh
```

Check if the script outputed errors, and try to fix them.

Run ```freonx``` to start GNOME.

Things that are working:

- video
- audio
- mouse and keyboard
- bluetooth/wifi
- suspend-resume
- switching back to chromeOS with a keyboard shortcut
- switching back to Fedora with a keyboard shortcut
- 3D hardware acceleration

Broken stuff:

- you have to run X as root (fedora related issue)
- you have to manually configure tap to click from GNOME
- you have to manually setup keybindings for going back to ChromeOS ```/bin/croutoncycle cros``` on CTRL+ALT+SHIFT+F1
- fedora isn't very happy to run without systemd
- not sure if it will work on non-Intel chromebook's
- keyboard bindings (haven't bothered with this, cause I don't need this)
- switching can sometimes be "wonky"

If you don't have Freon, you should be able to connect to the X server started by ChromeOS
with the included ```host-X11``` command from Crouton.

Tip: Use Fedy to install stuff. It works great with Fedora.

FAQ:
---

**How do I switch back?**

Type ```croutoncycle cros``` to the terminal. Tip: create a keyboard shortcut (CTRL+ALT+SHIFT+F1) for this
from GNOME settings. You can logout to exit GNOME and return to ChromeOS.

**How do I switch to Fedora?**

Type ```croutoncycle :0``` to another terminal or press CTRL+ALT+SHIFT+F2.

**How much space do I need?**

- ~3GB for the GNOME + CLI installation.
- ~500MB for CLI only.

**How to install other DE's?**

Modify ```install.sh``` script. It's really easy!

**My download is slow or not working...**

Modify the ```default``` file in ```installater/fedora``` folder. You can find mirrors on the
fedora mirror list site.

**What about Wine?**

Wine works fine. I've sucessfully installed Photoshop CS6 through the PlayOnLinux Wine front-end.

**Architecture?**

You can install an i686 chroot onto a x86_64 Chromebook. Specify ```-a i386``` to the installer. This way it will take
much less space, and you really don't lose anything. You will also need to run dnf with [BROKEN AT THE MOMENT DNF DOESN'T RESPECT]

**What about VirtualBox?**

VirtualBox would require a patched kernel, so please use the official Crouton if you need VirtualBox.

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
