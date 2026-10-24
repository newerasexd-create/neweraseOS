#!/usr/bin/env bash
set -e

echo "========================================================"
echo "          neweraseOS Local Build (WSL Arch)             "
echo "========================================================"

echo ">>> Updating pacman and ensuring archiso is installed..."
pacman -Sy --noconfirm --needed archiso

WORKDIR="/tmp/archiso-work"
OUTDIR="/mnt/f/obraz"
PROFILE="/mnt/f/linux/archiso"

echo ">>> Cleaning previous work dir..."
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR" "$OUTDIR"

echo ">>> Launching mkarchiso..."
mkarchiso -v -w "$WORKDIR" -o "$OUTDIR" "$PROFILE"

echo ">>> Finding and linking to neweraseOS.iso..."
LATEST_ISO=$(ls -t "$OUTDIR"/neweraseOS-*.iso 2>/dev/null | head -n 1)
if [ -n "$LATEST_ISO" ]; then
    cp -f "$LATEST_ISO" "$OUTDIR/neweraseOS.iso"
    echo "========================================================"
    echo " [ALL DONE] neweraseOS.iso successfully created in F:\obraz!"
    echo "========================================================"
fi
