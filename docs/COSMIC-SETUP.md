# 🪼 Jazzy Jellyfish OS - COSMIC Desktop Setup

Complete guide for installing and configuring COSMIC desktop environment on Arch Linux.

## Prerequisites

```bash
# Update system
pacman -Syu

# Install base packages
pacman -S base-devel git curl wget
```

## COSMIC Desktop Installation

### Option 1: From AUR (Recommended)

```bash
# Install yay or paru AUR helper
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si

# Install COSMIC desktop
paru -S cosmic-session cosmic-comp cosmic-panel cosmic-applets \
    cosmic-bg cosmic-edit cosmic-files cosmic-idle cosmic-launcher \
    cosmic-notifications cosmic-osd cosmic-randr cosmic-screenshot \
    cosmic-settings cosmic-store cosmic-term cosmic-workspaces \
    libcosmic cosmic-text
```

### Option 2: From Source (Latest)

```bash
# Clone COSMIC repositories
git clone https://github.com/pop-os/cosmic-session.git
cd cosmic-session && cargo build --release

# Repeat for other components...
```

## Display Manager Setup

### GDM (Recommended for COSMIC)

```bash
pacman -S gdm
systemctl enable gdm
```

### SDDM

```bash
pacman -S sddm
systemctl enable sddm
```

Add COSMIC session file to SDDM:
```bash
cat > /usr/share/xsessions/cosmic.desktop << 'EOF'
[Desktop Entry]
Name=COSMIC
Comment=COSMIC Desktop Environment
Exec=cosmic-session
Type=Application
EOF
```

## Post-Installation Configuration

### Enable Required Services

```bash
# NetworkManager
systemctl enable NetworkManager

# Bluetooth (if needed)
systemctl enable bluetooth

# Audio (PipeWire)
systemctl --user enable pipewire pipewire-pulse wireplumber
```

### User Configuration

```bash
# Add user to required groups
usermod -aG video,audio,input kilisan

# Set shell
chsh -s /bin/zsh kilisan
```

## Jazzy Jellyfish Customizations

### Wallpaper and Theme

```bash
# Install jellyfish wallpaper
mkdir -p /usr/share/backgrounds/jazzy-jellyfish
# Add wallpaper files...
```

### COSMIC Settings Export

```bash
# Export COSMIC config
mkdir -p ~/.config/cosmic
# Configure via GUI, then backup settings
```

## NVIDIA GPU Support

```bash
# Install NVIDIA drivers
pacman -S nvidia nvidia-utils nvidia-settings

# For Wayland, ensure DRM KMS is enabled
# Add to /etc/default/grub:
# GRUB_CMDLINE_LINUX_DEFAULT="... nvidia-drm.modeset=1"

# Create NVIDIA config
cat > /etc/modprobe.d/nvidia.conf << 'EOF'
options nvidia NVreg_PreserveVideoMemoryAllocations=1
options nvidia_drm modeset=1
EOF
```

## Security Hardening

### Firewall

```bash
pacman -S ufw
ufw default deny incoming
ufw default allow outgoing
ufw enable
systemctl enable ufw
```

### Hardened Kernel (Optional)

```bash
# Install linux-hardened
pacman -S linux-hardened linux-hardened-headers
```

## AI Development Tools

```bash
# Install Python and ML tools
pacman -S python python-pip python-jupyter python-pandas python-numpy

# Install Ollama for local LLM
curl -fsSL https://ollama.com/install.sh | sh
systemctl enable ollama

# Install conda (miniforge)
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh
```

## Troubleshooting

### Black Screen on Login

1. Switch to TTY (Ctrl+Alt+F2)
2. Check logs: `journalctl -u cosmic-session`
3. Try X11 session instead of Wayland

### NVIDIA Issues

```bash
# Check DRM status
cat /sys/module/nvidia_drm/parameters/modeset

# Should return: Y
```

## Links

- [COSMIC GitHub](https://github.com/pop-os/cosmic)
- [Jazzy Jellyfish Omni](https://github.com/BoozeLee/jazzy-jellyfish-omni)
- [Arch Wiki COSMIC](https://wiki.archlinux.org/title/COSMIC)
