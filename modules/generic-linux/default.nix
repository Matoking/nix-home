{ config, ... }:

{
  # Defaults to make Nix play nicer with non-NixOS distros
  targets.genericLinux.enable = true;
}
