{

  description = "nixos";

  inputs = {
    nixpkg.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/laptop.nix
          ./nixos/configuration.nix
        ];
      };
      pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/pc.nix
          ./nixos/configuration.nix
        ];
      };
    };
    homeConfigurations."tom" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home-manager/home.nix ];
    };
  };
}
