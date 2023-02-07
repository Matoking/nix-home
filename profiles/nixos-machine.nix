{ config, lib, ... }:

{
  imports = [
    ../modules/dev-tools/default.nix
    ../modules/git/default.nix
    ../modules/neovim/default.nix
    ../modules/zsh/default.nix
  ];

  programs.git = {
    userEmail = "janne.pulkkinen@protonmail.com";
    userName = "Janne Pulkkinen";
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
