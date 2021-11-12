{ config, lib, ... }:

with lib;

{
  imports = [
    # Fix for some locale issues with older distros
    ./multi-glibc-locale-paths.nix
  ];

  # Defaults to make Nix play nicer with non-NixOS distros
  targets.genericLinux.enable = true;

  programs.zsh.initExtraFirst = mkIf config.programs.zsh.enable ''
    # Required for some non-NixOS platforms
    export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
  '';
}
