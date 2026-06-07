{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      user = import ./user.nix;
    in
    {
      darwinConfigurations."Aden's Brain" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit user;
        };
        modules = [
          ./configuration.nix

          home-manager.darwinModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit user;
            };

            users.users.${user.username}.home = user.homeDirectory;

            home-manager.users.${user.username} = import ./home.nix;
          }
        ];
      };

      templates.research-python = {
        path = ./templates/research-python;
        description = "Python research project shell with Nix-pinned Python and uv-managed dependencies";
      };
    };
}
