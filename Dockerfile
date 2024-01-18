# Use a base image that supports systemd, for example, Debian
FROM debian:bullseye

# Install necessary packages
RUN apt-get update && \
    apt-get install -y shellinabox openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Cloudflared for Cloudflare Tunneling
RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared.deb && \
    rm -f cloudflared.deb

# Configure SSH
RUN echo 'root:root' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose necessary ports
EXPOSE 4200 22

# Start services (shellinabox, ssh, and cloudflared)
CMD ["/usr/bin/shellinaboxd", "-t", "-s", "/:LOGIN"] && \
    service ssh start && \
    cloudflared service install eyJhIjoiZTA5NzlkYjkzN2RhMDY4ODIzOTRkMWM3N2RkZTI4YWUiLCJ0IjoiY2QyNWYzODgtOWYxNS00NjVkLWEyNDEtNTRkYTQwMTk5ZmM5IiwicyI6Ik5ESTJObU13WVRndE5tWmlaQzAwTVRJM0xXSTVOell0WXpWbFlqRm1NekUyT1RNeiJ9
