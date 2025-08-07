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
          ./laptop.nix
	  ./configuration.nix
        ];
      };

      pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./pc.nix
	  ./configuration.nix
        ];
      };
    };
  };

}
