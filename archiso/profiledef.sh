#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="neweraseOS"
iso_label="NEWERASE_$(date +%Y%m)"
iso_publisher="neweraseOS Project <https://github.com/neweraseOS>"
iso_application="neweraseOS Gaming Desktop Live/Install Medium"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/passwd"]="0:0:644"
  ["/etc/group"]="0:0:644"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/liveuser"]="0:0:440"
  ["/root"]="0:0:750"
  ["/home/liveuser"]="1000:1000:755"
  ["/usr/local/bin/newerase-game-helper"]="0:0:755"
  ["/usr/local/bin/newerase-welcome"]="0:0:755"
  ["/usr/local/bin/install-portproton"]="0:0:755"
  ["/usr/local/bin/newerase-live-init.sh"]="0:0:755"
  ["/usr/local/bin/zen"]="0:0:755"
  ["/opt/zen/zen"]="0:0:755"
  ["/opt/happ/bin/Happ"]="0:0:755"
)
