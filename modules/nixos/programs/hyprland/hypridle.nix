{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib) toHyprconf;

  cfg = config.casa.profiles.graphical;
  settings = {
    general = {
      after_sleep_cmd = "hyprctl dispatch dpms on";
      before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      lock_cmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
    };
    listener = [
      {
        "on-timeout" = lib.getExe config.programs.hyprlock.package;
        timeout = 1400;
      }
      {
        "on-resume" = "hyprctl dispatch dpms on";
        "on-timeout" = "hyprctl dispatch dpms off";
        timeout = 1600;
      }
      {
        "on-timeout" = "${pkgs.systemd}/bin/systemctl suspend";
        timeout = 2800;
      }
    ];
  };
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz.xdg.config.files."hypr/hypridle.conf" = {
      generator = attrs: toHyprconf { inherit attrs; };
      value = settings;
    };

    services.hypridle.enable = true;
  };
}
