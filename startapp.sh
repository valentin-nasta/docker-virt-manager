#!/bin/sh
export HOME=/config
dbus-uuidgen --ensure=/etc/machine-id
exec /usr/local/bin/virt-manager --no-fork
