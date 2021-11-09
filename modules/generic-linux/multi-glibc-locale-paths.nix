# Copied from https://gist.github.com/peti/2c818d6cb49b0b0f2fd7c300f8386bc3
{ config, lib, pkgs, ... }:          # multi-glibc-locale-paths.nix

with lib;

/*
 * Provide version-specific LOCALE_ARCHIVE environment variables to mitigate
 * the effects of https://github.com/NixOS/nixpkgs/issues/38991.
 */

let

  # A random Nixpkgs revision *before* the default glibc
  # was switched to version 2.27.x.
  oldpkgsSrc = pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "0252e6ca31c98182e841df494e6c9c4fb022c676";
    sha256 = "1sr5a11sb26rgs1hmlwv5bxynw2pl5w4h5ic0qv3p2ppcpmxwykz";
  };

  oldpkgs = import oldpkgsSrc {};

  # A random Nixpkgs revision *after* the default glibc
  # was switched to version 2.27.x.
  newpkgsSrc = pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "1d0a71879dac0226272212df7a2463d8eeb8f75b";
    sha256 = "0nh6wfw50lx6wkzyiscfqg6fl6rb17wmncj8jsdvbgmsd6rm95rg";
  };

  newpkgs = import newpkgsSrc {};

in

{
  programs.zsh.sessionVariables = {
    LOCALE_ARCHIVE_2_11 = "/lib/locale/locale-archive";
    LOCALE_ARCHIVE_2_27 = "${newpkgs.glibcLocales}/lib/locale/locale-archive";
  };

  # Create a wrapper script for ZSH to ensure we can insert the environment
  # variables early enough during initialization. This is necessary when
  # we're connecting to the machine using SSH.
  home.packages = mkIf config.programs.zsh.enable [
    (pkgs.writeScriptBin "zsh-wrapped" ''
      #!/bin/sh
      export LOCALE_ARCHIVE_2_11="${config.programs.zsh.sessionVariables.LOCALE_ARCHIVE_2_11}"
      export LOCALE_ARCHIVE_2_27="${config.programs.zsh.sessionVariables.LOCALE_ARCHIVE_2_27}"
      exec ${pkgs.zsh}/bin/zsh "$@"
    '')
  ];
}
