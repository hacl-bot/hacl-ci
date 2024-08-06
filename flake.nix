{
  description = "Everest CI";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "flake-utils";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      agenix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.doc = pkgs.callPackage ./doc { };
      }
    )
    // {
      nixosConfigurations = {
        everest-ci = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            ./base.nix
            ./hardware.nix
            ./fusion-inventory.nix
            #./catala.nix
            ./github-runners.nix
            ./gitlab-runner.nix
            ./cachix.nix
          ];
        };
      };
    };
}
