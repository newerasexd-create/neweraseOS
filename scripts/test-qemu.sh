#!/usr/bin/env bash
# ====================================================================
# neweraseOS - Test ISO in QEMU Virtual Machine
# ====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_DIR="$PROJECT_ROOT/out"
ISO_FILE="$(ls -t "$OUT_DIR"/*.iso 2>/dev/null | head -n 1)"

if [ -z "$ISO_FILE" ]; then
    echo "[-] No ISO found in $OUT_DIR. Build it first with ./scripts/build.sh or download from GitHub Actions."
    exit 1
fi

echo "[+] Booting $ISO_FILE in QEMU (4 Cores, 4GB RAM, UEFI)..."
qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -smp 4 \
    -vga virtio \
    -display gtk,gl=on \
    -cdrom "$ISO_FILE" \
    -boot d
