{ lib, pkgs, ... }:
{
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      # Web browsers
      firefox = {
        executable = "${lib.getBin pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };
      chromium = {
        executable = "${pkgs.chromium}/bin/chromium";
        profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
      };

      # Communication
      thunderbird = {
        executable = "${pkgs.thunderbird}/bin/thunderbird";
        profile = "${pkgs.firejail}/etc/firejail/thunderbird.profile";
      };
      discord = {
        executable = "${pkgs.discord}/bin/discord";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      };

      # Media and document viewers
      vlc = {
        executable = "${pkgs.vlc}/bin/vlc";
        profile = "${pkgs.firejail}/etc/firejail/vlc.profile";
      };
      evince = {
        executable = "${pkgs.evince}/bin/evince";
        profile = "${pkgs.firejail}/etc/firejail/evince.profile";
      };

      # Office applications
      libreoffice = {
        executable = "${pkgs.libreoffice}/bin/libreoffice";
        profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
      };

      # Graphics and creative applications
      gimp = {
        executable = "${pkgs.gimp}/bin/gimp";
        profile = "${pkgs.firejail}/etc/firejail/gimp.profile";
      };
    };
  };
}
