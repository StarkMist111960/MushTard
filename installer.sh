#!/bin/bash

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

log()    { echo -e "${GREEN}[✔]${RESET} $1"; }
warn()   { echo -e "${YELLOW}[!]${RESET} $1"; }
error()  { echo -e "${RED}[✖]${RESET} $1" >&2; exit 1; }

if [[ $EUID -ne 0 ]]; then
    error "Please run this script as root, yu retard (sudo bash $0)"
fi

log "Starting MushMTard Installer"

CROSH="/usr/bin/crosh"
MURK_DIR="/mnt/stateful_partition/murkmod"
BOOT_MSG="/usr/share/chromeos-assets/text/boot_messages/en/self_repair.txt"
MUSHM_URL="https://raw.githubusercontent.com/NonagonWorkshop/MurkPlugins/main/utils/mushm.sh"
# CROSH_URL="https://raw.githubusercontent.com/NonagonWorkshop/MurkPlugins/main/utils/crosh.sh"

log "Creating directories..."
mkdir -p "$MURK_DIR/mush"
# mkdir -p "$MURK_DIR/mush"
# touch "$MURK_DIR/mush/mushm.sh"
mkdir -p "$MURK_DIR/plugins" "$MURK_DIR/pollen" || error "Failed to create MurkMod directories"

log "Installing MushMTard"
curl -fsSLo "$CROSH" "$MUSHM_URL" || error "Failed to download MushMTard cause ur shit is fucked like you!"
# curl -fsSLo "$MURK_DIR/mush/mushm.sh" "MUSHM_URL" || error "Failed to download MushM"

if [[ -w "$(dirname "$BOOT_MSG")" ]]; then
    log "Customizing boot message..."
    cat <<'EOF' > "$BOOT_MSG"
Oops, your system is as Fucked as you,
Hold tight while we try to repair it...
EOF
else
    warn "Cannot modify boot message because your computer is fucked (permission denied or path missing retarded ass computer.)"
fi

log "Installation complete!"
echo -e "${YELLOW}Made by Star_destroyer11${RESET}"
echo -e "${RED}Modified by Jmoney46 (for retards)${RESET}"
echo -e "${GREEN}MushMTard installed. Don't fuck shit up${RESET}"
