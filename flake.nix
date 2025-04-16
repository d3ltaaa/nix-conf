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
    {
      nixosConfigurations = {
        #   "T480" = nixpkgs-unstable.lib.nixosSystem {
        #     # nixpkgs-unstable -> pkgs
        #     system = "x86_64-linux";
        #     specialArgs = {
        #       inherit nixpkgs-stable;
        #       inherit scripts;
        #     };
        #     modules = [
        #       ./nixos/default/configuration.nix
        #       ./nixos/machines/T480/hardware-configuration.nix
        #       ./nixos/machines/T480/extra-configuration.nix
        #       inputs.home-manager.nixosModules.home-manager
        #       {
        #         home-manager.useGlobalPkgs = true;
        #         home-manager.useUserPackages = true;
        #         home-manager.extraSpecialArgs = { inherit inputs; };
        #         home-manager.users.falk.imports = [
        #           ./home.nix
        #           ./home-manager/machines/T480/hyprland.nix
        #         ];
        #       }
        #       # {
        #       #   nixpkgs.config.allowUnfree = true;
        #       #   nixpkgs.config.allowUnfreePredicate = (pkg: true);
        #       # }
        #     ];
        #   };
        #
        #   "T440P" = nixpkgs-unstable.lib.nixosSystem {
        #     # nixpkgs-unstable -> pkgs
        #     system = "x86_64-linux";
        #     specialArgs = {
        #       inherit nixpkgs-stable;
        #       inherit scripts;
        #     };
        #     modules = [
        #       ./nixos/default/configuration.nix
        #       ./nixos/machines/T440P/hardware-configuration.nix
        #       ./nixos/machines/T440P/extra-configuration.nix
        #       inputs.home-manager.nixosModules.home-manager
        #       {
        #         home-manager.useGlobalPkgs = true;
        #         home-manager.useUserPackages = true;
        #         home-manager.extraSpecialArgs = { inherit inputs; };
        #         home-manager.users.falk.imports = [
        #           ./home.nix
        #           ./home-manager/machines/T440P/hyprland.nix
        #         ];
        #       }
        #       # {
        #       #   nixpkgs.config.allowUnfree = true;
        #       #   nixpkgs.config.allowUnfreePredicate = (pkg: true);
        #       # }
        #     ];
        #   };

        "PC" = nixpkgs-unstable.lib.nixosSystem {
          # nixpkgs-unstable -> pkgs
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit nixpkgs-stable;
            inherit scripts;
          };
          modules = [
            ./system/hosts/PC/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.falk.imports = [
                ./home/hosts/PC/home.nix
              ];
            }
            # {
            #   nixpkgs.config.allowUnfree = true;
            #   nixpkgs.config.allowUnfreePredicate = (pkg: true);
            # }
          ];
        };
        # homeManagerModules.default = ./home/modules;
      };
    };
}
