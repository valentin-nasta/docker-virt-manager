# Pull base build image.
FROM alpine AS builder

# Add testing repo for ssh-askpass
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install packages.
RUN apk --update --upgrade add \
	bash libressl-dev openssh xterm dbus-x11 \
	py3-gobject3 libosinfo libxml2 build-base python3 \
	gtk+3.0 vte3 py3-libxml2 spice-gtk gtk-vnc>=0.5.2-r2 \
	ttf-dejavu gnome-icon-theme dconf intltool grep \
	libvirt-glib py-urlgrabber py-ipaddr py3-libvirt \
	py3-requests py3-urllib3 py3-chardet py3-certifi py3-idna \
	py2-gobject3 perl-dev file git openssh-askpass \
   && rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]*

# Download virt-manager from git
RUN git clone https://github.com/virt-manager/virt-manager.git

# Install virt-manager with script from developer
RUN cd virt-manager && ./setup.py configure --prefix=/usr/local && ./setup.py install --exec-prefix=/usr/local

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.9

# Add testing repo for ssh-askpass
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Add community repo for some python packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories

# Install packages.
RUN apk --update --upgrade add \
		bash py3-configparser py3-libvirt py3-libxml2 py-ipaddr \
    virt-manager-common openssh-askpass libressl py-urlgrabber \
		gnome-icon-theme dconf grep file openssh dbus-x11 \
   && rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]*

# Virt-manager wants ssh-askpass without "gtk" in the name, adds 9.7KB to the total container size
RUN cp /usr/lib/ssh/gtk-ssh-askpass /usr/lib/ssh/ssh-askpass

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://www.alteeve.com/w/images/2/26/Striker01-v2.0-virtual-machine-manager_icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Copy the start script.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Copy Virt-Manager from base build image.
COPY --from=builder /usr/local /usr/local

# Set the name of the application.
ENV APP_NAME="virt-manager"
