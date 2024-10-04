{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.ironbar.homeManagerModules.default];
  programs.ironbar = {
    enable = true;
    systemd = true;
    config = {
      position = "top";
      start = [
        {
          type = "workspaces";
          name_map = {
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
          };
          favorites = ["1" "2" "3" "4" "5"];
        }
      ];
      end = [
        {
          type = "tray";
          icon_size = 20;
        }
        {
          type = "custom";
          name = "applets";
          bar = [
            {
              type = "volume";
              format = "{icon}";
              icons = {
                volume_high = "";
                volume_medium = "󰖀";
                volume_low = "󰕿";
                muted = "󰖁 ";
              };
              # tooltip-format = "{volume}%";
              # on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            }
            {
              type = "network_manager";
              icon_size = 20;
            }
          ];
        }
        {
          type = "clock";
          format = "%I:%M %p | %D";
        }
      ];
    };

    style = builtins.readFile ./style.css;
  };
}
