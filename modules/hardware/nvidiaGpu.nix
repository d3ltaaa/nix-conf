{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.nvidiaGpu = {
      enable = lib.mkEnableOption "Enables Nvidia module";
      enableGpu = lib.mkEnableOption "Enable Nvidia GPU";
      intelBusId = lib.mkOption {
        type = lib.types.str;
        default = "PCI:0@0:2:0";
      };
      nvidiaBusId = lib.mkOption {
        type = lib.types.str;
        default = "PCI:0@01:0:0";
      };
    };
  };
  config = lib.mkIf config.hardware.nvidiaGpu.enable (
    lib.mkMerge [
      (lib.mkIf (config.hardware.nvidiaGpu.enableGpu == true) {
        # enable nvidia
        hardware.graphics = {
          enable = true;
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          powerManagement.finegrained = true;

          open = false;

          nvidiaSettings = true;

          package = config.boot.kernelPackages.nvidiaPackages.stable;

          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            intelBusId = config.hardware.nvidiaGpu.intelBusId;
            nvidiaBusId = config.hardware.nvidiaGpu.nvidiaBusId;
          };
        };

      })
      (lib.mkIf (config.hardware.nvidiaGpu.enableGpu == false) {
        # disable nvidia
        boot.extraModprobeConfig = ''
          blacklist nouveau
          options nouveau modeset=0
        '';

        services.udev.extraRules = ''
          # Remove NVIDIA USB xHCI Host Controller devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA USB Type-C UCSI devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA Audio devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA VGA/3D controller devices
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
        '';
        boot.blacklistedKernelModules = [
          "nouveau"
          "nvidia"
          "nvidia_drm"
          "nvidia_modeset"
        ];
      })
    ]
  );
}
