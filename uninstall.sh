#!/bin/bash
#
# uninstall.sh
# Uninstaller for VMware Kali Display Fix
#

echo "=== VMware Kali Display Fix Uninstaller ==="
echo ""

# Stop running instances
echo "[*] Stopping any running instances..."
pkill -f vmware-resize-monitor.sh 2>/dev/null || true

# Remove files
echo "[*] Removing vmware-resize-monitor.sh..."
rm -f ~/.local/bin/vmware-resize-monitor.sh

echo "[*] Removing autostart entry..."
rm -f ~/.config/autostart/vmware-resize-monitor.desktop

echo ""
echo "=== Uninstall Complete ==="
echo ""
echo "The VMware display fix has been removed."
echo ""
