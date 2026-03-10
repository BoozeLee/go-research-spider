#!/bin/bash
# Jazzy Jellyfish OS - BIOS/UEFI Unlock Script
# Run from Arch ISO live environment or chroot

set -e

echo "🪼 Jazzy Jellyfish OS - BIOS/UEFI Unlock Tool"
echo "=============================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

# Detect boot mode
if [ -d /sys/firmware/efi/efivars ]; then
    BOOT_MODE="UEFI"
    echo -e "${GREEN}✓ Boot Mode: UEFI${NC}"
else
    BOOT_MODE="BIOS"
    echo -e "${YELLOW}⚠ Boot Mode: Legacy BIOS${NC}"
fi

# Mount EFI variables if needed
if [ "$BOOT_MODE" = "UEFI" ]; then
    if ! mountpoint -q /sys/firmware/efi/efivars 2>/dev/null; then
        echo "Mounting EFI variables..."
        mount -t efivarfs efivarfs /sys/firmware/efi/efivars 2>/dev/null || true
    fi
fi

# Check Secure Boot status
if [ "$BOOT_MODE" = "UEFI" ]; then
    SB_STATUS=$(od -An -t u1 /sys/firmware/efi/vars/SecureBoot-*/data 2>/dev/null | tr -d ' ' || echo "unknown")
    if [ "$SB_STATUS" = "1" ]; then
        echo -e "${YELLOW}⚠ Secure Boot: ENABLED${NC}"
        echo "  To disable: Enter BIOS/UEFI setup and disable Secure Boot"
        echo "  Or use MokManager to enroll custom keys"
    elif [ "$SB_STATUS" = "0" ]; then
        echo -e "${GREEN}✓ Secure Boot: DISABLED${NC}"
    else
        echo -e "${YELLOW}? Secure Boot: Unknown${NC}"
    fi
fi

# Show current boot entries (UEFI only)
if [ "$BOOT_MODE" = "UEFI" ]; then
    echo ""
    echo "Current UEFI Boot Entries:"
    efibootmgr -v 2>/dev/null || echo "  efibootmgr not available"
fi

# Function to add UEFI Firmware Settings to GRUB
add_uefi_firmware_entry() {
    echo ""
    echo "Adding UEFI Firmware Settings entry to GRUB..."
    
    MNT_ROOT="${1:-/mnt}"
    GRUB_CUSTOM="$MNT_ROOT/etc/grub.d/40_custom"
    
    if [ ! -f "$GRUB_CUSTOM" ]; then
        echo -e "${RED}Error: $GRUB_CUSTOM not found${NC}"
        return 1
    fi
    
    # Check if entry already exists
    if grep -q "UEFI Firmware Settings" "$GRUB_CUSTOM" 2>/dev/null; then
        echo "  Entry already exists"
        return 0
    fi
    
    # Add the entry
    cat >> "$GRUB_CUSTOM" << 'EOF'

if [ ${grub_platform} == "efi" ]; then
    menuentry 'UEFI Firmware Settings' --id 'uefi-firmware' {
        fwsetup
    }
fi
EOF
    
    echo -e "${GREEN}✓ Added UEFI Firmware Settings entry${NC}"
    echo "  Run 'grub-mkconfig -o /boot/grub/grub.cfg' to apply"
}

# Function to install GRUB with Secure Boot support
install_grub_secure() {
    echo ""
    echo "Installing GRUB with Secure Boot support..."
    
    ESP_MOUNT="${1:-/boot}"
    
    # Check if ESP is mounted
    if ! mountpoint -q "$ESP_MOUNT" 2>/dev/null; then
        echo -e "${RED}Error: ESP not mounted at $ESP_MOUNT${NC}"
        return 1
    fi
    
    # Install GRUB
    grub-install --target=x86_64-efi \
        --efi-directory="$ESP_MOUNT" \
        --bootloader-id="GRUB" \
        --modules="tpm" \
        --disable-shim-lock
    
    # Regenerate config
    grub-mkconfig -o /boot/grub/grub.cfg
    
    echo -e "${GREEN}✓ GRUB installed${NC}"
}

# Function to setup Secure Boot keys with sbctl
setup_secure_boot_keys() {
    echo ""
    echo "Setting up Secure Boot keys with sbctl..."
    
    if ! command -v sbctl &> /dev/null; then
        echo -e "${YELLOW}sbctl not installed. Install with: pacman -S sbctl${NC}"
        return 1
    fi
    
    # Create keys
    sbctl create-keys
    
    # Enroll keys
    sbctl enroll-keys
    
    echo -e "${GREEN}✓ Secure Boot keys created and enrolled${NC}"
}

# Main menu
echo ""
echo "Options:"
echo "  1. Add UEFI Firmware Settings to GRUB (from chroot)"
echo "  2. Show boot entries"
echo "  3. Check Secure Boot status"
echo "  4. Exit"
echo ""
read -p "Select option: " choice

case $choice in
    1)
        read -p "Enter chroot mount point [/mnt]: " chroot
        chroot=${chroot:-/mnt}
        add_uefi_firmware_entry "$chroot"
        ;;
    2)
        efibootmgr -v
        ;;
    3)
        if [ "$BOOT_MODE" = "UEFI" ]; then
            SB_STATUS=$(od -An -t u1 /sys/firmware/efi/vars/SecureBoot-*/data 2>/dev/null | tr -d ' ')
            echo "Secure Boot status: $SB_STATUS (1=enabled, 0=disabled)"
        else
            echo "Not running in UEFI mode"
        fi
        ;;
    *)
        echo "Exiting..."
        ;;
esac

echo ""
echo "🪼 Jazzy Jellyfish OS - Done"
