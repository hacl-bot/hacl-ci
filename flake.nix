{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , agenix
    ,
    }:
    flake-utils.lib.eachDefaultSystem
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          packages.doc = pkgs.callPackage ./doc { };
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nixos-rebuild
            ];
          };
        }
      )
    // {
      nixosConfigurations = {
        hacl-ci = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            ./base.nix
            ./hardware.nix
            ./github-runners.nix
            ./gitlab-runner.nix
            ./cachix.nix
          ];
        };
      };
    };
}
