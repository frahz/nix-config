{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  cfg = config.casa.profiles.graphical;
  sources = config.catppuccin.sources;
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = builtins.attrValues {
        inherit (pkgs) awww mako;
      };
      extraDependencies = builtins.attrValues {
        inherit (pkgs) blueman tailscale udiskie;
      };

      xdg.config.files = {
        "mako/config".text = ''
          border-radius=5
          border-size=1
          default-timeout=5000
          font=Berkeley Mono 14
          include=${sources.mako}/catppuccin-mocha/catppuccin-mocha-pink
        '';
        "udiskie/config.yml" = {
          generator = (pkgs.formats.yaml { }).generate "udiskie-config.yml";
          value.program_options = {
            automount = true;
            notify = true;
            tray = false;
          };
        };
      };

      systemd.services = {
        awww = {
          description = "awww-daemon";
          wantedBy = singleton "graphical-session.target";
          partOf = singleton "graphical-session.target";
          after = singleton "graphical-session.target";
          unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
          serviceConfig = {
            Environment = "PATH=$PATH:${pkgs.awww}/bin";
            ExecStart = lib.getExe' pkgs.awww "awww-daemon";
            Restart = "always";
            RestartSec = 10;
          };
        };
        blueman-applet = {
          description = "Blueman applet";
          wantedBy = singleton "graphical-session.target";
          partOf = singleton "graphical-session.target";
          requires = singleton "tray.target";
          after = [
            "graphical-session.target"
            "tray.target"
          ];
          serviceConfig.ExecStart = lib.getExe' pkgs.blueman "blueman-applet";
        };
        tailscale-systray = {
          description = "Official Tailscale systray application for Linux";
          wantedBy = singleton "graphical-session.target";
          partOf = singleton "graphical-session.target";
          requires = singleton "tray.target";
          after = [
            "graphical-session.target"
            "tray.target"
          ];
          serviceConfig.ExecStart = "${lib.getExe pkgs.tailscale} systray";
        };
        udiskie = {
          description = "udiskie mount daemon";
          wantedBy = singleton "graphical-session.target";
          partOf = singleton "graphical-session.target";
          after = singleton "graphical-session.target";
          serviceConfig.ExecStart = lib.getExe pkgs.udiskie;
        };
      };
    };
  };
}
