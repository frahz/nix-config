{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        modules-left = ["hyprland/workspaces"];
        modules-center = [];
        modules-right = ["tray" "group/group-applets" "clock"];

        clock = {
          # calendar = {
          #   format = {today = "<span color='#b4befe'><b>{}</b></span>";};
          # };
          format = "{:%I:%M %p | %D}";
          tooltip = "false";
          # tooltip-format = ''
          #   <big>{:%Y %B}</big>
          #   <tt><small>{calendar}</small></tt>'';
          # format-alt = " {:%m/%d/%y}";
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
        };

        pulseaudio = {
          format = "{icon}";
          format-muted = "󰖁 ";
          format-icons = {
            default = ["󰕿" "󰖀" " "];
          };
          tooltip-format = "{volume}%";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        network = {
          format-wifi = " ";
          format-ethernet = "󰈀 ";
          tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "󰖪 ";
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
}
