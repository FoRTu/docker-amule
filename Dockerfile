FROM debian:stable-slim

# Some info about the author
LABEL maintainer="FoRTu" \
maintainet.email="me@fortu.io" \
maintainer.website="https://github.com/FoRTu/docker-amule"

# Software installation and minimum configuration
RUN apt update && \
apt upgrade -y && \
apt install -y amule-daemon pwgen git && \
git clone https://github.com/MatteoRagni/AmuleWebUI-Reloaded.git /usr/share/amule/webserver/AmuleWebUI-Reloaded && \
apt purge -y curl && \
apt-get -y autoclean && \
apt-get -y autoremove && \
rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/locale/* \
        /var/cache/debconf/*-old \
        /var/lib/apt/lists/* \
        /usr/share/doc/* \
        /usr/share/man/* \
mkdir {/Incoming,/Temp} && \
useradd -ms /bin/bash amule && \
sed -i 's,^\(AMULED_USER[ ]*=\).*,\1'"amule"',g' /etc/default/amule-daemon

# Add launcher script
ADD launcher.sh /launcher.sh
RUN chmod +x /launcher.sh

# Define TCP/IP ports
EXPOSE 4711/tcp
EXPOSE 4672/udp
EXPOSE 4665/tcp
EXPOSE 4662/tcp

# Set user
USER amule

ENTRYPOINT ["/launcher.sh"]
