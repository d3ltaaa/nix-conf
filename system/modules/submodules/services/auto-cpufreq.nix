{ ... }:
{
  services.auto-cpufreq = {
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_bias = "power";
        energy_performance_preference = "power";
        turbo = "auto";
        enable_thresholds = true;
        start_threshold = 90;
        stop_threshold = 95;
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
