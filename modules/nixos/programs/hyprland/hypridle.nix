{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (self.lib) toHyprconf;

  cfg = config.casa.profiles.graphical;
  user = config.hjem.users.frahz;
  settings = {
    general = {
      after_sleep_cmd = "hyprctl dispatch dpms on";
      before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      lock_cmd = "pidof hyprlock || ${lib.getExe pkgs.hyprlock}";
    };
    listener = [
      {
        "on-timeout" = lib.getExe pkgs.hyprlock;
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
    hjem.users.frahz = {
      extraDependencies = singleton pkgs.hypridle;

      xdg.config.files."hypr/hypridle.conf" = {
        generator = attrs: toHyprconf { inherit attrs; };
        value = settings;
      };

      systemd.services.hypridle = {
        description = "hypridle";
        wantedBy = singleton "graphical-session.target";
        partOf = singleton "graphical-session.target";
        after = singleton "graphical-session.target";
        unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
        serviceConfig = {
          ExecStart = lib.getExe pkgs.hypridle;
          Restart = "always";
          RestartSec = 10;
        };
        restartTriggers = singleton user.xdg.config.files."hypr/hypridle.conf".source;
      };
    };
  };
}
