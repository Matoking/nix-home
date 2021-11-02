{ config, lib, ... }:

{
  imports = [
    ../modules/base/default.nix
    ../modules/git/default.nix
    ../modules/neovim/default.nix
  ];

  programs.git = {
    userEmail = "janne.pulkkinen@csc.fi";
    userName = "Janne Pulkkinen";
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vagrant";
  home.homeDirectory = "/home/vagrant";

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
