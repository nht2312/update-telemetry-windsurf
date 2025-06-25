#!/bin/bash

# Require root
if [[ $EUID -ne 0 ]]; then
  echo "❌ This script must be run as root. Please use: sudo ./wds-setup.sh"
  exit 1
fi

set -e

function install_windsurf() {
  echo "🔧 Installing WindSurf IDE..."

  sudo apt-get update
  sudo apt-get install -y wget gpg

  wget -qO- "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | gpg --dearmor > windsurf-stable.gpg
  sudo install -D -o root -g root -m 644 windsurf-stable.gpg /etc/apt/keyrings/windsurf-stable.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/windsurf-stable.gpg] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null
  rm -f windsurf-stable.gpg

  sudo apt install -y apt-transport-https
  sudo apt update
  sudo apt install -y windsurf

  echo "✨ Installing extension IDE ..."

  windsurf --install-extension arifbudimanar.arifcode-theme
  windsurf --install-extension phil294.git-log--graph
  windsurf --install-extension laravel.vscode-laravel
  windsurf --install-extension shufo.vscode-blade-formatter
  windsurf --install-extension onecentlin.laravel-blade
  windsurf --install-extension amiralizadeh9480.laravel-extra-intellisense
  windsurf --install-extension mrchetan.goto-laravel-components
  windsurf --install-extension mrchetan.laravel-goto-config
  windsurf --install-extension codingyu.laravel-goto-view
  windsurf --install-extension porifa.laravel-intelephense
  windsurf --install-extension open-southeners.laravel-pint
  windsurf --install-extension mohamedbenhida.laravel-intellisense
  windsurf --install-extension onecentlin.laravel5-snippets
  windsurf --install-extension naoray.laravel-goto-components
  windsurf --install-extension stef-k.laravel-goto-controller
  windsurf --install-extension doonfrs.livewire-support
  windsurf --install-extension xyz.local-history
  windsurf --install-extension pkief.material-icon-theme
  windsurf --install-extension bradlc.vscode-tailwindcss
  windsurf --install-extension imgildev.vscode-tailwindcss-snippets
  windsurf --install-extension wayou.vscode-todo-highlight
  windsurf --install-extension bmewburn.vscode-intelephense-client

  echo "✅ WindSurf IDE installed successfully!"
}

function uninstall_windsurf() {
  echo "🧹 Uninstalling WindSurf IDE..."

  sudo apt remove --purge -y windsurf
  sudo rm -f /etc/apt/sources.list.d/windsurf.list
  sudo rm -f /etc/apt/keyrings/windsurf-stable.gpg
  sudo apt update
  sudo apt autoremove --purge -y
  rm -rf ~/.config/windsurf ~/.local/share/windsurf

  echo "✅ WindSurf IDE has been completely removed!"
}

echo "============================"
echo "     WIND SURF IDE TOOL     "
echo "============================"
echo "1. Install WindSurf IDE"
echo "2. Uninstall WindSurf IDE completely"
echo "0. Exit"
read -p "👉 Enter your choice (0-2): " choice

case "$choice" in
  1)
    install_windsurf
    ;;
  2)
    uninstall_windsurf
    ;;
  0)
    echo "👋 Goodbye!"
    exit 0
    ;;
  *)
    echo "❌ Invalid choice."
    exit 1
    ;;
esac
