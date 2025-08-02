{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
{
  services.hypridle = {
    inherit (osConfig.casa.profiles.graphical) enable;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };
      listener = [
        {
          timeout = 1400;
          on-timeout = "${lib.getExe config.programs.hyprlock.package}";
        }
        {
          timeout = 1600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 2800;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
