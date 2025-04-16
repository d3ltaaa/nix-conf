{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    amdgpu-module.enable = lib.mkEnableOption "Enables Amdgpu module";
  };
  config = lib.mkIf config.amdgpu-module.enable {
    environment.systemPackages = with pkgs; [
      lact
    ];

    systemd.services.lact = {
      description = "AMDGPU Control Daemon";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
      enable = true;
    };
  };
}
