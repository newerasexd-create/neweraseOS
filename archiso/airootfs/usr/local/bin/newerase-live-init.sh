#!/usr/bin/env bash
set -e

# Ensure root has no password lock
passwd -d root || true

# Create liveuser if not present
if ! id -u liveuser >/dev/null 2>&1; then
    useradd -m -g users -G wheel,audio,video,storage,optical,input,network -s /bin/bash liveuser
    passwd -d liveuser || true
    echo "liveuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/liveuser
    chmod 0440 /etc/sudoers.d/liveuser
    
    # Ensure home permissions
    if [ -d /etc/skel ]; then
        cp -r /etc/skel/. /home/liveuser/
    fi
    chown -R liveuser:users /home/liveuser
fi

# Enable virtualbox guest service if in virtualbox
if systemctl list-unit-files | grep -q vboxservice.service; then
    systemctl start vboxservice.service || true
fi
