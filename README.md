# VMware Kali Linux Display Auto-Resize Fix

A workaround for the VMware Tools `vmware-user` GTK crash bug that prevents automatic display resizing in Kali Linux VMs running on VMware Workstation.

## The Problem

When running Kali Linux in VMware Workstation, the guest display doesn't automatically resize to match the VMware window. This results in black borders around the VM display.

The root cause is a bug in `vmware-user` (part of `open-vm-tools-desktop`) where it crashes immediately on startup with the error:

```
(vmware-user:XXXX): Gtk-WARNING **: gtk_disable_setlocale() must be called before gtk_init()
```

This prevents the automatic display resize functionality from working, even though:
- `open-vm-tools` service is running
- `vmwgfx` driver is loaded correctly
- VMware Tools is properly installed

## Tested Environment

- **Host OS:** Windows 11
- **Hypervisor:** VMware Workstation
- **Guest OS:** Kali Linux (Rolling)
- **Package Version:** open-vm-tools-desktop 2:13.0.5-1

## Solution

Since the `vmware-user` daemon crashes due to a GTK initialization bug, this workaround uses a simple bash script that polls `xrandr` to automatically adjust the display resolution.

### Quick Install

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/vmware-kali-display-fix.git
cd vmware-kali-display-fix

# Run the installer
chmod +x install.sh
./install.sh

# Log out and log back in for changes to take effect
```

### Manual Install

1. Create the monitor script:

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/vmware-resize-monitor.sh << 'EOF'
#!/bin/bash
# VMware Display Resize Monitor
# Workaround for vmware-user GTK crash bug
# Polls xrandr every 3 seconds to auto-adjust display resolution

while true; do
    xrandr --output Virtual-1 --auto 2>/dev/null
    sleep 3
done
EOF
chmod +x ~/.local/bin/vmware-resize-monitor.sh
```

2. Create the autostart entry:

```bash
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/vmware-resize-monitor.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=VMware Resize Monitor
Comment=Workaround for vmware-user GTK crash - auto-adjusts display resolution
Exec=/home/YOUR_USERNAME/.local/bin/vmware-resize-monitor.sh
Hidden=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5
EOF
```

3. Log out and log back in.

## Files

| File | Description |
|------|-------------|
| `vmware-resize-monitor.sh` | Main script that polls xrandr for display changes |
| `vmware-resize-monitor.desktop` | Autostart entry for GNOME/XFCE |
| `install.sh` | Automated installer script |
| `uninstall.sh` | Removes the fix |

## Troubleshooting

### Display name is different

If your display isn't named `Virtual-1`, find the correct name:

```bash
xrandr | grep " connected"
```

Then edit the script to use the correct output name.

### Script not starting on login

Check if the autostart entry exists:

```bash
ls -la ~/.config/autostart/vmware-resize-monitor.desktop
```

Verify the script path in the desktop file matches your actual username.

### Login screen glitch

The login screen (GDM) may appear duplicated or glitched. This is cosmetic - once you log in, the display normalizes. This happens because the script runs in the user session, not at the display manager level.

## Uninstall

```bash
# Remove the script and autostart entry
rm ~/.local/bin/vmware-resize-monitor.sh
rm ~/.config/autostart/vmware-resize-monitor.desktop

# Kill any running instances
pkill -f vmware-resize-monitor
```

Or run the uninstall script:

```bash
./uninstall.sh
```

## Why Not Just Use VMware Tools?

We tried several approaches before settling on this workaround:

1. **open-vm-tools-desktop** - `vmware-user` crashes with GTK error
2. **Reinstalling open-vm-tools-desktop** - Same crash
3. **Official VMware Tools ISO** - Same issue
4. **Various GTK environment tweaks** (`GDK_BACKEND=x11`, `dbus-launch`, etc.) - None prevented the crash
5. **VMware Workstation display settings** - Stretch mode doesn't fix resolution, just scales

The polling script is a reliable workaround until the upstream bug is fixed.

## Contributing

Feel free to submit issues or pull requests if you have improvements or find this works (or doesn't work) on other configurations.

## License

MIT License - See [LICENSE](LICENSE) file.

## Author

Created by [DJ](https://github.com/YOUR_USERNAME) - Vexera Consulting LLC
