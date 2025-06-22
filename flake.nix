{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    scripts.url = "github:d3ltaaa/fscripts";
    scripts.flake = false;

  };
  outputs =
    {
      nixpkgs-unstable,
      nixpkgs-stable,
      scripts,
      ...
    }@inputs:
    let
      user = "falk";
    in
    {
      nixosConfigurations = {
        "T480" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-stable = import nixpkgs-stable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/T480/configuration.nix
            ./modules/default.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-flatpak.nixosModules.nix-flatpak
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }
          ];
        };

        "T440P" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-stable = import nixpkgs-stable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/T440P/configuration.nix
            ./modules/default.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }
          ];
        };

        "PC" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-stable = import nixpkgs-stable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/PC/configuration.nix
            ./modules/default.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }
          ];
        };
        "WIREGUARD-SERVER" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-stable = import nixpkgs-stable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/WIREGUARD-SERVER/configuration.nix
            ./modules/default.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
          ];
        };
        "SERVER" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-stable = import nixpkgs-stable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/SERVER/configuration.nix
            ./modules/default.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }
          ];
        };
        "PC-SERVER" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit scripts;
            nixpkgs-stable = import nixpkgs-stable {
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/PC-SERVER/configuration.nix
            ./modules/default.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.${user}.imports = [
                inputs.nixvim.homeManagerModules.nixvim
              ];
            }
          ];
        };
      };
    };
}
