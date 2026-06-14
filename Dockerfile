FROM debian:13

# Universally required APT packages
RUN apt-get update \
        && apt-get install -y --no-install-recommends ca-certificates wget cron \
        && rm -rf /var/lib/apt/lists/*

# Installation if AMD64 architecture
RUN if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
            echo "deb http://download.proxmox.com/debian/pbs-client trixie main" > /etc/apt/sources.list.d/pbs-client.list \
            && wget -q https://enterprise.proxmox.com/debian/proxmox-release-trixie.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-trixie.gpg \
            && apt-get update \
            && apt-get install -y --no-install-recommends proxmox-backup-client \
            && rm -rf /var/lib/apt/lists/*; \
    fi

COPY entrypoint.sh /entrypoint.sh
COPY do_backup.sh /do_backup.sh
RUN chmod +x /entrypoint.sh && chmod +x /do_backup.sh
CMD ["/entrypoint.sh"]
