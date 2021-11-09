{ config, ... }:

{
  imports = [
    # Fix for some locale issues with older distros
    ./multi-glibc-locale-paths.nix
  ];

  # Defaults to make Nix play nicer with non-NixOS distros
  targets.genericLinux.enable = true;
}
