{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    applications.configuration.virtualisation.vbox.enable =
      lib.mkEnableOption "Enables virtualbox module";
    applications.configuration.virtualisation.kvmqemu.enable =
      lib.mkEnableOption "Enables kvmqemu module";
  };
  config = (
    lib.mkMerge [
      # VirtualBox config block
      (lib.mkIf config.applications.configuration.virtualisation.vbox.enable {
        users.groups.vboxusers.members = [ "${config.settings.users.primary}" ];

        virtualisation.virtualbox = {
          host = {
            enable = true;
            enableExtensionPack = false;
            addNetworkInterface = true;
            enableKvm = false;
          };
          guest = {
            enable = true;
            dragAndDrop = true;
            clipboard = true;
          };
        };
      })

      # KVM/QEMU/libvirt config block
      (lib.mkIf config.applications.configuration.virtualisation.kvmqemu.enable {
        programs.virt-manager = {
          enable = true;
          package = pkgs.virt-manager;
        };

        virtualisation.spiceUSBRedirection.enable = true;

        users.groups.libvirtd.members = [ "${config.settings.general.users.primary}" ];
        users.groups.libvirt.members = [ "${config.settings.general.users.primary}" ];

        environment.variables.LIBVIRT_DEFAULT_URI = "qemu:///system";

        virtualisation.libvirtd = {
          enable = true;
          package = pkgs.libvirt;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
            ovmf = {
              enable = true;
              packages = [
                (pkgs.OVMF.override {
                  secureBoot = true;
                  tpmSupport = true;
                }).fd
              ];
            };
          };
        };

        environment.systemPackages = with pkgs; [
          virt-viewer
          vde2
          dnsmasq
          bridge-utils
          netcat-openbsd
          libguestfs
          guestfs-tools
          libosinfo
        ];
        # Home Manager as NixOS module
        home-manager.users.${config.settings.users.primary} =
          { config, ... }:
          {
            dconf.settings = {
              "org/virt-manager/virt-manager/connections" = {
                autoconnect = [ "qemu:///system" ];
                uris = [ "qemu:///system" ];
              };
            };
          };
      })
    ]
  );
}
