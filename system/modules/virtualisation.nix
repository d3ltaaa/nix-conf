{
  lib,
  config,
  pkgs,
  variables,
  ...
}:

{
  options = {
    virtualisation-module = {
      enable = lib.mkEnableOption "Enables Virtualisation module";
      vbox.enable = lib.mkEnableOption "Enables Virtualbox options";
      kvmqemu.enable = lib.mkEnableOption "Enables KVM, Qemu and libvirt options";
    };
  };

  config = lib.mkIf config.virtualisation-module.enable (
    lib.mkMerge [

      # VirtualBox config block
      (lib.mkIf config.virtualisation-module.vbox.enable {
        users.groups.vboxusers.members = [ "${variables.user}" ];

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
      (lib.mkIf config.virtualisation-module.kvmqemu.enable {
        programs.virt-manager = {
          enable = true;
          package = pkgs.virt-manager;
        };

        virtualisation.spiceUSBRedirection.enable = true;

        users.groups.libvirtd.members = [ "${variables.user}" ];
        users.groups.libvirt.members = [ "${variables.user}" ];

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
      })
    ]
  );
}
