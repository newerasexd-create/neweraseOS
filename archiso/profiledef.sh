#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="neweraseOS"
iso_label="NEWERASE_$(date +%Y%m)"
iso_publisher="neweraseOS Project <https://github.com/neweraseOS>"
iso_application="neweraseOS Gaming Desktop Live/Install Medium"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.systemd-boot.esp' 'uefi-x64.systemd-boot.esp'
           'uefi-ia32.systemd-boot.eltorito' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/sudoers.d"]="0:0:750"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/newerase-game-helper"]="0:0:755"
  ["/usr/local/bin/newerase-welcome"]="0:0:755"
  ["/usr/local/bin/install-portproton"]="0:0:755"
)
