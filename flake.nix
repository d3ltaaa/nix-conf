{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";

    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    scripts.url = "github:d3ltaaa/fscripts";
    scripts.flake = false;

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    # hyprland-plugins.inputs.hyprland.follows = "hyprland";
  };
  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-stable,
      scripts,
      ...
    }@inputs:
    let
      variables = {
        user = "falk";
        userHomeDir = "/home/falk";
      };
    in
    {
      nixosConfigurations = {
        "T480" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit nixpkgs-stable;
            inherit scripts;
            inherit variables;
          };
          modules = [
            ./system/hosts/T480/configuration.nix
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit variables;
              };
              home-manager.users.${variables.user}.imports = [
                ./home/hosts/T480/home.nix
              ];
            }
          ];
        };

        "T440P" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit nixpkgs-stable;
            inherit scripts;
            inherit variables;
          };
          modules = [
            ./system/hosts/T440P/configuration.nix
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t440p
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit variables;
              };
              home-manager.users.${variables.user}.imports = [
                ./home/hosts/T440P/home.nix
              ];
            }
          ];
        };

        "PC" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit nixpkgs-stable;
            inherit scripts;
            inherit variables;
          };
          modules = [
            ./system/hosts/PC/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit variables;
              };
              home-manager.users.${variables.user}.imports = [
                ./home/hosts/PC/home.nix
              ];
            }
          ];
        };
      };
    };
}
