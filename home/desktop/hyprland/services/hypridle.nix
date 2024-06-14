{
  config,
  lib,
  pkgs,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };
      listener = [
        {
          timeout = 400;
          on-timeout = "${lib.getExe config.programs.hyprlock.package}";
        }
        {
          timeout = 330;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
