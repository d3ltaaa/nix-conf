{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.amdGpu.enable = lib.mkEnableOption "Enables Amdgpu module";
  };
  config = lib.mkIf config.hardware.amdGpu.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];

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

    # had to change /etc/lact/config.yaml (admin_group -> admin_groups (with - wheel and - sudo))
  };
}
