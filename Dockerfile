# Pull base build image.
FROM alpine:3.10 AS builder

# Install packages.
RUN apk add \
        bash libressl-dev xterm dbus-x11 \
        py3-gobject3 libosinfo libxml2 build-base python3 \
        gtk+3.0-dev vte3 py3-libxml2 spice-gtk gtk-vnc py3-cairo\
        ttf-dejavu gnome-icon-theme dconf intltool grep \
        libvirt-glib py3-urlgrabber py3-ipaddr py3-libvirt \
        py3-requests py3-urllib3 py3-chardet py3-certifi py3-idna \
        perl-dev file git && \
    apk add openssh-askpass --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    && rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]*

# Download virt-manager from git
RUN git clone https://github.com/virt-manager/virt-manager.git

# Install virt-manager with script from developer
RUN cd virt-manager && ./setup.py configure --prefix=/usr/local && ./setup.py install --exec-prefix=/usr/local

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.10

# Install packages.
RUN apk add \
        py3-configparser py3-libvirt py3-libxml2 \
        py3-ipaddr virt-manager-common dbus-x11 \
        bash libressl dconf grep file \
        gnome-icon-theme adwaita-icon-theme && \
    apk add gtksourceview4 --repository http://dl-3.alpinelinux.org/alpine/edge/community/ && \
    apk add openssh-askpass --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    && rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]* /usr/share/icons/Adwaita/cursors /usr/share/icons/gnome/256x256 && \
    # Virt-manager wants ssh-askpass without "gtk" in the name
    ln -s /usr/lib/ssh/gtk-ssh-askpass /usr/lib/ssh/ssh-askpass

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://www.alteeve.com/w/images/2/26/Striker01-v2.0-virtual-machine-manager_icon.png && \
    install_app_icon.sh "$APP_ICON_URL" \
    && rm -rf /var/cache/apk/*

# Copy the start script.
COPY startapp.sh /startapp.sh

# Copy Virt-Manager from base build image.
COPY --from=builder /usr/local /usr/local

# Set the name of the application.
ENV APP_NAME="virt-manager"
