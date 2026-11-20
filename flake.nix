{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixpkgs-mesa.url = "github:NixOS/nixpkgs/ef34387";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    # Home Manager's packages. NixOS sets allowUnfree in its own config, but
    # Home Manager doesn't see that, so it's set here too. The overlay builds
    # the Firefox add-ons with these pkgs, so they get allowUnfree as well.
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.firefox-addons.overlays.default ];
    };
  in
  {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          ./nixos/laptop.nix
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations."tom" =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs; };

        modules = [
          ./home-manager/home.nix
        ];
      };
  };
}
