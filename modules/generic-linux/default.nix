{ config, lib, ... }:

with lib;

{
  # Defaults to make Nix play nicer with non-NixOS distros
  targets.genericLinux.enable = true;

  programs.zsh.initContent = mkIf config.programs.zsh.enable (mkBefore ''
    # Required for some non-NixOS platforms
    export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
  '');
}
