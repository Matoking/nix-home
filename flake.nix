{
  description = "Home manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    homeConfigFor = profile: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [ ./profiles/${profile}.nix ];
    };
  in
  {
    homeConfigurations = {
      home = homeConfigFor "home";
      nixos-machine = homeConfigFor "nixos-machine";
      work-vagrant = homeConfigFor "work-vagrant";
    };
    userProfiles = {
      home = import ./profiles/home.nix;
      nixos-machine = import ./profiles/nixos-machine.nix;
      nixos-pc = import ./profiles/nixos-pc.nix;
      work-vagrant = import ./profiles/work-vagrant.nix;
    };
  };
}
