{ pkgs, ... }:
{
  programs.virt-manager = {
    enable = true;
    package = pkgs.virt-manager;
  };

  virtualisation.spiceUSBRedirection.enable = true;

  users.groups.libvirtd.members = [ "falk" ];
  users.groups.libvirt.members = [ "falk" ];

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
}
