{ ... }:
{
  services.getty = {
    autologinOnce = true;
    autologinUser = "falk";
    # loginProgram = "${pkgs.shadow}/bin/hyprland";
  };
}
