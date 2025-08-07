{ lib, config, ... }:
{
  services.flatpak = lib.mkIf config.applications.packages.libraries.flatpaks.default {
    packages = [
      "com.bitwarden.desktop"
    ];
  };
}
