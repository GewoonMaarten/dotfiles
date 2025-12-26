#!/bin/bash

set -eu

# Install stow if not installed already
if ! command -v stow >/dev/null 2>&1; then
    echo "Stow not found."

    if [ -f /etc/os-release ]; then
        . /etc/os-release
    fi

    if [ "${ID:-}" = "ubuntu" ]; then
        echo "Ubuntu detected. Installing stow..."
        sudo apt update
        sudo apt install -y stow
        echo ""
    else
        echo "Please install GNU Stow manually:"
        echo "https://www.gnu.org/software/stow/"
    fi
fi

for p in nix home-manager
do
    echo "Invoking stow for package '$p'"
    stow --adopt -t ~ $p
done

if [ "${XDG_SESSION_TYPE:-}" = "wayland" ]; then
    echo "Wayland detected. Installing gdk config"
    stow --adopt -t ~ "environment.d"
fi
