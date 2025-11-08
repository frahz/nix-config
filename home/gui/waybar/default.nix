{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
in
{
  config = mkIf (cfg.profiles.graphical.enable && isLinux) {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          position = "top";
          layer = "top";
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ ];
          modules-right = [
            "tray"
            "group/group-applets"
            "clock"
          ];

          clock = {
            format = "{:%I:%M %p | %D}";
            tooltip = "false";
            tooltip-format = ''<tt><big>{calendar}</big></tt>'';
            calendar = {
              format = {
                months = "<span color='#f5bde6'>{}</span>";
                days = "<span color='#F2F0E5'>{}</span>";
                weekdays = "<span color='#F2F0E5'>{}</span>";
                today = "<span color='#F2F0E5'>{}</span>";
              };
            };
            actions = {
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

          "hyprland/workspaces" = {
            active-only = false;
            disable-scroll = true;
            format = "{icon}";
            on-click = "activate";
            format-icons = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
              "10" = "〇";
              sort-by-number = true;
            };
            persistent-workspaces = {
              "*" = 5;
            };
          };

          tray = {
            icon-size = 20;
            spacing = 8;
            show-passive-items = true;
          };

          pulseaudio = {
            format = "{icon}";
            format-muted = "󰖁 ";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            tooltip-format = "{volume}%";
            on-click = "${lib.getExe pkgs.pwvucontrol}";
          };

          network = {
            format-wifi = " ";
            format-ethernet = "󰈀 ";
            tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪 ";
            on-click = "${lib.getExe pkgs.iwmenu} --launcher fuzzel";
          };

          "group/group-applets" = {
            orientation = "inherit";
            modules = [
              "pulseaudio"
              "network"
            ];
          };
        };
      };
      style = builtins.readFile ./style.css;
    };
  };
}
