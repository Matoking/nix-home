#!/bin/sh
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
sudo chsh -s "$HOME/.nix-profile/bin/zsh" "$(whoami)"
