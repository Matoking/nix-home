#!/bin/sh
echo "$HOME/.nix-profile/bin/zsh-wrapped" | sudo tee -a /etc/shells
sudo chsh -s "$HOME/.nix-profile/bin/zsh-wrapped" "$(whoami)"
