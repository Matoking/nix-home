#!/bin/bash
set -eu

current_pwd=$(pwd)
profile_to_install="$1"

if [ ! -f "$current_pwd/profiles/$profile_to_install.nix" ]; then
    echo "The profile $profile_to_install does not exist.";
    exit 1;
fi

command -v wget > /dev/null || {
    echo "wget is not installed!"
    exit 1;
}

if ! command -v nix; then
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

    # Source the Nix-generated file to ensure Nix is available
    set +eu  # Disable error checking temporarily
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    set -eu
fi

# Check if Nix is working as expected
nix-instantiate '<nixpkgs>' -A hello

if ! command -v home-manager; then
    echo 'Installing Home Manager...'
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager || true
    nix-channel --update || true

    nix-shell '<home-manager>' -A install
fi

touch "$HOME/.profile"

if ! grep "hm-session-vars" "$HOME/.profile"; then
    echo 'Adding hm-session-vars.sh to ~/.profile';
    echo "source \"$HOME/.nix-profile/etc/profile.d/nix.sh\"" >> "$HOME/.profile";
    echo "source \"$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh\"" >> "$HOME/.profile";

    set +eu  # Disable error checking temporarily
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    set -eu
fi

# Check if Home Manager is working
home-manager --version

mkdir -p "$HOME/.config/home-manager" || true;
rm "$HOME/.config/home-manager/home.nix" || true;
ln -s "$current_pwd/profiles/$profile_to_install.nix" "$HOME/.config/home-manager/home.nix";

# Finally, install the new configuration
home-manager switch
