{ config, lib, ... }:

{
  imports = [
    ../modules/base/default.nix
    ../modules/dev-tools/default.nix
    ../modules/fish/default.nix
    ../modules/generic-linux/default.nix
    ../modules/git/default.nix
    ../modules/kitty/default.nix
    ../modules/wezterm/default.nix
    ../modules/neovim/default.nix
    ../modules/zsh/default.nix
  ];

  programs.git.settings = {
    user.email = "janne.pulkkinen@protonmail.com";
    user.name = "Janne Pulkkinen";
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "matoking";
  home.homeDirectory = "/home/matoking";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
