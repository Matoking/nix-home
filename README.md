# nix-home-manager

1. Install [Nix](https://nixos.org/download.html)

2. Install [Home Manager](https://rycee.gitlab.io/home-manager/)

3. Create symlink

```
rm $HOME/.config/nixpkgs/home.nix
ln -s $HOME/git/nix-home-manager/profiles/home.nix $HOME/.config/nixpkgs/home.nix
```

4. Add the following line into `~/.zshrc`

```
source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
```

5. Just run `home-manager switch` from now on whenever you need to update the current configuration
