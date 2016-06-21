#!/bin/sh
#fix permissions:
sudo chown 1000:1000 /usr/bin/Xorg
sudo chown 1000:1000 /tmp/crouton-lock -R
#start trigger service:
croutontriggerd &
#startx:
DBUS_SYSTEM_BUS_ADDRESS='unix:path=/var/host/dbus/system_bus_socket' LD_PRELOAD='/usr/local/lib/croutonfreon.so' XARGS='-nolisten tcp' croutonpowerd -i startx -- vt7
