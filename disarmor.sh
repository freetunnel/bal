#!/bin/bash
# =================================================================
#  Disable AppArmor Total di Ubuntu 22.xx & 25.xx
#  By: FREETUNNEL
# =================================================================

set -e

echo "[*] Stop & disable service AppArmor..."
systemctl stop apparmor 2>/dev/null || true
systemctl disable --now apparmor 2>/dev/null || true
systemctl mask apparmor 2>/dev/null || true

echo "[*] Tambahkan parameter kernel apparmor=0 ke GRUB..."
GRUB_FILE="/etc/default/grub"
BACKUP_FILE="/etc/default/grub.bak.$(date +%F_%H-%M-%S)"

# Backup grub sebelum edit
cp "$GRUB_FILE" "$BACKUP_FILE"

if grep -q "apparmor=0" "$GRUB_FILE"; then
    echo "    -> Sudah ada apparmor=0 di GRUB_CMDLINE_LINUX"
else
    sed -i 's/^GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="apparmor=0 /' "$GRUB_FILE"
fi

echo "[*] Update grub..."
update-grub >/dev/null

echo "[*] Hapus paket AppArmor..."
apt purge -y apparmor apparmor-utils >/dev/null || true
apt autoremove -y >/dev/null || true

echo "[*] Update initramfs..."
update-initramfs -u >/dev/null

echo "[*] Selesai. Silakan reboot untuk mematikan AppArmor total!"
