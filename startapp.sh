#!/bin/sh
export HOME=/config
dbus-uuidgen --ensure=/etc/machine-id
dbus-uuidgen --ensure
exec /usr/local/bin/virt-manager --no-fork
