#!/bin/bash
#
# vmware-resize-monitor.sh
# VMware Display Resize Monitor for Kali Linux
#
# Workaround for vmware-user GTK crash bug that prevents
# automatic display resizing in VMware Workstation guests.
#
# This script polls xrandr every 3 seconds to automatically
# adjust the display resolution when the VMware window is resized.
#
# Author: DJ - Vexera Consulting LLC
# Repository: https://github.com/YOUR_USERNAME/vmware-kali-display-fix
#

# Configuration
OUTPUT_NAME="Virtual-1"
POLL_INTERVAL=3

# Main loop
while true; do
    xrandr --output "$OUTPUT_NAME" --auto 2>/dev/null
    sleep "$POLL_INTERVAL"
done
