{
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeManagerModules.catppuccin
    ./home-manager/theme.nix
    ./home-manager/programs/foot.nix
    ./home-manager/programs/hyprland.nix
    ./home-manager/programs/waybar.nix
    ./home-manager/programs/git.nix
    ./home-manager/programs/tmux.nix
    ./home-manager/programs/neovim/default.nix
    ./home-manager/programs/lf.nix
    ./home-manager/programs/dunst.nix
    ./home-manager/programs/rofi.nix
    ./home-manager/programs/zsh.nix
  ];

  home.username = "falk";
  home.homeDirectory = "/home/falk";

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = "${config.home.homeDirectory}/Dokumente";
    download = "${config.home.homeDirectory}/Downloads";
    pictures = "${config.home.homeDirectory}/Bilder";
    music = "${config.home.homeDirectory}/Audio";
    videos = "${config.home.homeDirectory}/Videos";
    templates = null;
    publicShare = null;
    desktop = null;
    extraConfig = {
      XDG_SYNC_DIR = "${config.home.homeDirectory}/Sync";
    };
  };

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";
  home.sessionPath = [
    "/home/falk/.scripts/"
    "/home/falk/.scripts/app_names/"
    "/home/falk/.scripts/system_scripts/"
    "/home/falk/.scripts/theme_scripts/"
    "/home/falk/.scripts/dwmblocks_scripts/"
    "/home/falk/.scripts/test_scripts/"
  ];
  programs.home-manager.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
