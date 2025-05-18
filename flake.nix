{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  {
    darwinConfigurations."Aden's Brain" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix

        # home-manager module
        home-manager.darwinModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          users.users.aden.home = "/Users/aden";

          home-manager.users.aden = import ./home.nix;
        }
      ];
    };
  };
}

