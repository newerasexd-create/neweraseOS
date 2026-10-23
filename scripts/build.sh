#!/usr/bin/env bash
# ====================================================================
# neweraseOS - Local Build Script (Arch Linux / archiso)
# ====================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ARCHISO_PROFILE="$PROJECT_ROOT/archiso"
WORK_DIR="/tmp/newerase-build-work"
OUT_DIR="$PROJECT_ROOT/out"

if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run as root (sudo ./scripts/build.sh)"
  exit 1
fi

echo "[+] Checking build dependencies..."
pacman -Sy --needed --noconfirm archiso git zstd

echo "[+] Cleaning old build artifacts..."
rm -rf "$WORK_DIR"
mkdir -p "$OUT_DIR"

echo "[+] Starting mkarchiso build..."
mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$ARCHISO_PROFILE"

echo "[+] Build complete! Your ISO is ready at:"
ls -lh "$OUT_DIR"/*.iso
