#!/bin/bash
#
# install.sh
# Installer for VMware Kali Display Fix
#

set -e

echo "=== VMware Kali Display Fix Installer ==="
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create directories
echo "[*] Creating directories..."
mkdir -p ~/.local/bin
mkdir -p ~/.config/autostart

# Install the monitor script
echo "[*] Installing vmware-resize-monitor.sh..."
cp "$SCRIPT_DIR/vmware-resize-monitor.sh" ~/.local/bin/
chmod +x ~/.local/bin/vmware-resize-monitor.sh

# Install autostart entry with correct home path
echo "[*] Installing autostart entry..."
sed "s|\$HOME|$HOME|g" "$SCRIPT_DIR/vmware-resize-monitor.desktop" > ~/.config/autostart/vmware-resize-monitor.desktop

# Kill any existing instances
echo "[*] Stopping any existing instances..."
pkill -f vmware-resize-monitor.sh 2>/dev/null || true

# Start the monitor
echo "[*] Starting vmware-resize-monitor..."
nohup ~/.local/bin/vmware-resize-monitor.sh > /dev/null 2>&1 &

echo ""
echo "=== Installation Complete ==="
echo ""
echo "The display resize monitor is now running."
echo "It will start automatically on future logins."
echo ""
echo "To verify it's running:"
echo "  pgrep -a vmware-resize"
echo ""
