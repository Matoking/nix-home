#!/bin/sh
# Disable SELinux if it's enabled; otherwise we will be unable to login
# when the new shell is enabled
sudo setenforce 0 || true

echo "$HOME/.nix-profile/bin/zsh-wrapped" | sudo tee -a /etc/shells
sudo chsh -s "$HOME/.nix-profile/bin/zsh-wrapped" "$(whoami)"
