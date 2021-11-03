#!/bin/bash
set -eu

current_pwd=$(pwd)
profile_to_install="$1"

if [ ! -f "$current_pwd/profiles/$profile_to_install.nix" ]; then
    echo "The profile $profile_to_install does not exist.";
    exit 1;
fi

nix_path=$(command -v nix)
if [ -z "$nix_path" ]; then
    echo 'Installing Nix...'
    wget -O /tmp/nix_install https://releases.nixos.org/nix/nix-2.3.16/install || true;
    found_hash=$(sha256sum /tmp/nix_install)
    correct_hash="0133a0670d72e07ef6658ddd095765ba1c73909d97de1e17c4e246b5fc8c8e15"
    if [[ ! "$found_hash" == "$correct_hash"* ]]; then
        echo 'Incorrect hash found, aborting...'
        exit 1;
    fi
    chmod +x /tmp/nix_install;
    /tmp/nix_install;
fi

# Check if Nix is working as expected
nix-instantiate '<nixpkgs>' -A hello

home_manager_path=$(command -v home-manager)
if [ -z "$home_manager_path" ]; then
    echo 'Installing Home Manager...'
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager || true
    nix-channel --update || true

    nix-shell '<home-manager>' -A install
fi

# Check if Home Manager is working
home-manager --version

rm "$HOME/.config/nixpkgs/home.nix";
ln -s "$current_pwd/profiles/$profile_to_install.nix" "$HOME/.config/nixpkgs/home.nix";

# Finally, install the new configuration
home-manager switch