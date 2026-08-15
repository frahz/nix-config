{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  cfg = config.casa.profiles.graphical;
  user = config.hjem.users.frahz;
  settings = singleton {
    position = "top";
    layer = "top";
    modules-left = singleton "hyprland/workspaces";
    modules-center = [ ];
    modules-right = [
      "tray"
      "group/group-applets"
      "clock"
    ];
    clock = {
      format = "{:%I:%M %p | %D}";
      tooltip = "false";
      tooltip-format = "<tt><big>{calendar}</big></tt>";
      calendar.format = {
        months = "<span color='#f5bde6'>{}</span>";
        days = "<span color='#F2F0E5'>{}</span>";
        weekdays = "<span color='#F2F0E5'>{}</span>";
        today = "<span color='#F2F0E5'>{}</span>";
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
      persistent-workspaces."*" = 5;
    };
    tray = {
      icon-size = 20;
      spacing = 8;
      show-passive-items = true;
    };
    pulseaudio = {
      format = "{icon}";
      format-muted = "󰖁 ";
      format-icons.default = [
        "󰕿"
        "󰖀"
        "󰕾"
      ];
      tooltip-format = "{volume}%";
      on-click = lib.getExe pkgs.pwvucontrol;
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
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = singleton pkgs.waybar;
      xdg.config.files = {
        "waybar/config" = {
          source = (pkgs.formats.json { }).generate "waybar-config.json" settings;
        };
        "waybar/style.css".source = ./style.css;
      };
      systemd = {
        targets.tray = {
          description = "System Tray";
          requires = singleton "graphical-session-pre.target";
        };
        services.waybar = {
          description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
          documentation = singleton "https://github.com/Alexays/Waybar/wiki";
          wantedBy = [
            "tray.target"
            "graphical-session.target"
          ];
          partOf = [
            "tray.target"
            "graphical-session.target"
          ];
          after = singleton "graphical-session.target";
          unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
          serviceConfig = {
            ExecStart = lib.getExe pkgs.waybar;
            ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
            KillMode = "mixed";
            Restart = "on-failure";
          };
          reloadTriggers = [
            user.xdg.config.files."waybar/config".source
            user.xdg.config.files."waybar/style.css".source
          ];
        };
      };
    };
  };
}
