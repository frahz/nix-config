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
          noise = 0.0117;
        }
      ];
      general = {
        grace = 2;
      };
      input-field = [
        {
          monitor = mainMonitor;
          size = "200, 40";
          position = "0, 100";
          outline_thickness = 2;
          rounding = 8;

          outer_color = "rgb(a6adc8)";
          inner_color = "rgb(1e1e2e)";
          font_color = "rgb(a6adc8)";

          capslock_color = "rgb(eba0ac)";
          check_color = "rgb(f9e2af)";
          fail_color = "rgb(f38ba8)";
          fail_text = ''<span font_family="Iosevka">$FAIL <b>($ATTEMPTS)</b></span>'';
          fail_transition = 300;

          placeholder_text = ''<span font_family="Iosevka"><b>Password...</b></span>'';
          swap_font_color = false;
          fade_on_empty = false;
          dots_size = 0.2;
          dots_spacing = 0.64;
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
          color = "rgb(a6adc8)";
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
          color = "rgb(a6adc8)";
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
