{
  variables,
  ...
}:
{
  services.getty = {
    autologinUser = "${variables.user}";
    # loginProgram = "${pkgs.shadow}/bin/hyprland";
  };
}
