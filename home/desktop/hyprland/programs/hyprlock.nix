{pkgs, ...}: {
  programs.hyprlock = {
    enable = true;
    settings = let
      mainMonitor = "HDMI-A-1";
    in {
      background = let
        wallpaper = "~/Pictures/GORIhEsX0AA4Pmt.jpg";
      in [
        {
          monitor = mainMonitor;
          path = wallpaper;
          blur_passes = 3;
          blur_size = 4;
          brightness = 0.5;
        }
      ];
      general = {
        grace = 2;
      };
      input-field = [
        {
          monitor = mainMonitor;
          size = "250, 50";
          position = "0, 100";
          outline_thickness = 3;

          outer_color = "rgb(7c6f64)";
          inner_color = "rgba(40, 40, 40, 0.8)";
          font_color = "rgb(ebdbb2)";

          fail_text = "$FAIL <b>($ATTEMPTS)</b>";
          placeholder_text = "Password...";
          swap_font_color = false;
          fade_on_empty = false;
          dots_spacing = 0.2;
          dots_center = true;

          halign = "center";
          valign = "bottom";
        }
      ];
      label = [
        {
          monitor = mainMonitor;
          text = ''
            cmd[update:1000] echo $(date +"%A, %B %-d")
          '';
          color = "rgb(ebdbb2)";
          font_family = "Iosevka Slab";
          position = "0, -80";
          valign = "top";
          halign = "center";
        }
        {
          monitor = mainMonitor;
          text = ''
            cmd[update:1000] echo $(date +"%-I:%M")
          '';
          color = "rgb(ebdbb2)";
          font_family = "New York";
          font_size = 120;
          position = "0, -100";
          valign = "top";
          halign = "center";
        }
      ];
    };
  };
}
