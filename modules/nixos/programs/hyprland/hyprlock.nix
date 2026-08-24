{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.lib) toHyprconf;
  cfg = config.casa.profiles.graphical;
  settings = {
    background = {
      monitor = "HDMI-A-1";
      blur_passes = 3;
      blur_size = 4;
      brightness = 0.5;
      noise = 0.0117;
      path = "~/Pictures/GORIhEsX0AA4Pmt.jpg";
    };
    "input-field" = {
      monitor = "HDMI-A-1";
      size = "200, 40";
      capslock_color = "rgb(eba0ac)";
      check_color = "rgb(f9e2af)";
      dots_center = true;
      dots_size = 0.2;
      dots_spacing = 0.64;
      fade_on_empty = false;
      fail_color = "rgb(f38ba8)";
      fail_text = ''<span font_family="Noto Sans">$FAIL <b>($ATTEMPTS)</b></span>'';
      font_color = "rgb(a6adc8)";
      halign = "center";
      inner_color = "rgb(1e1e2e)";
      outer_color = "rgb(a6adc8)";
      outline_thickness = 2;
      placeholder_text = ''<span font_family="Noto Sans"><b>Password...</b></span>'';
      position = "0, 100";
      rounding = 8;
      swap_font_color = false;
      valign = "bottom";
    };
    label = [
      {
        monitor = "HDMI-A-1";
        color = "rgb(a6adc8)";
        font_family = "Noto Sans";
        halign = "center";
        position = "0, -80";
        text = ''cmd[update:1000] echo $(date +"%A, %B %-d")'';
        valign = "top";
      }
      {
        monitor = "HDMI-A-1";
        color = "rgb(a6adc8)";
        font_family = "Noto Serif Display";
        font_size = 120;
        halign = "center";
        position = "0, -100";
        text = ''cmd[update:1000] echo $(date +"%-I:%M")'';
        valign = "top";
      }
    ];
  };
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz.xdg.config.files."hypr/hyprlock.conf" = {
      generator = attrs: toHyprconf { inherit attrs; };
      value = settings;
    };
    programs.hyprlock.enable = true;
  };
}
