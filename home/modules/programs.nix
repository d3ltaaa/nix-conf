{ lib, config, ... }:
{
  imports = [
    ./submodules/programs/neovim/default.nix
    ./submodules/programs/dunst.nix
    ./submodules/programs/foot.nix
    ./submodules/programs/git.nix
    ./submodules/programs/hyprland.nix
    ./submodules/programs/lf.nix
    ./submodules/programs/rofi.nix
    ./submodules/programs/tmux.nix
    ./submodules/programs/waybar.nix
    ./submodules/programs/zsh.nix
    ./submodules/programs/swappy.nix
  ];
}
