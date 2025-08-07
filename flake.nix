{

  description = "nixos";
  inputs = {
    nixpkg.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/laptop.nix
	  ./nixos/configuration.nix
        ];
      };

      pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/pc.nix
	  ./nixos/configuration.nix
        ];
      };
    };
  };

}
