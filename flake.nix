{
  description = "Everest CI";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, agenix, }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        everest-ci = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            agenix.nixosModules.age
            ./base.nix
            ./hardware.nix
            ./fusion-inventory.nix
            #./catala.nix
            ./cache.nix
            ./github-runner.nix
            ./gitlab-runner.nix
            ./cachix.nix
          ];
        };
      };
    };
}
