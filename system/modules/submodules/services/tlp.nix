{ lib, config, ... }:
{
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "";
      CPU_SCALING_GOVERNOR_ON_BAT = "";

      CPU_ENERGY_PERF_POLICY_ON_AC = "";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "";

      PLATFORM_PROFILE_ON_AC = "";
      PLATFORM_PROFILE_ON_BAT = "";

      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersupersave";

      DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth nfc wwan";
      DEVICES_TO_DISABLE_ON_SHUTDOWN = "bluetooth nfc wifi wwan";
      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth nfc wifi wwan";

      DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
      DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";

      # CPU_SCALING_GOVERNOR_ON_AC = "performance";
      # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      #
      # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      #
      # PLATFORM_PROFILE_ON_AC = "performance";
      # PLATFORM_PROFILE_ON_BAT = "low-power";
      #
      # CPU_BOOST_ON_AC = 1;
      # CPU_BOOST_ON_BAT = 1;
      #
      # CPU_HWP_DYN_BOOST_ON_AC = 1;
      # CPU_HWP_DYN_BOOST_ON_BAT = 1;

      #CPU_MIN_PERF_ON_AC = 0;
      #CPU_MAX_PERF_ON_AC = 100;
      #CPU_MIN_PERF_ON_BAT = 0;
      #CPU_MAX_PERF_ON_BAT = 20;

      #Optional helps save long term battery health
      # START_CHARGE_THRESH_BAT0 = 60; # 60 and below it starts to charge
      # STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above it stops charging

    };
  };
}
