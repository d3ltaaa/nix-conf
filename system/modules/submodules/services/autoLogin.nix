{
  variables,
  ...
}:
{
  services.getty = {
    autologinOnce = true;
    autologinUser = "${variables.user}";
    # loginProgram = "${pkgs.shadow}/bin/hyprland";
  };
}
