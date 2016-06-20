#!/bin/sh
#start trigger service:
sudo su -c 'croutontriggerd &'
#startx:
sudo DBUS_SYSTEM_BUS_ADDRESS='unix:path=/var/host/dbus/system_bus_socket' LD_PRELOAD='/usr/local/lib/croutonfreon.so' XARGS='-nolisten tcp' croutonpowerd -i startx :1
