_: {
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "HDMI-A-1,2560x1440@143.91, 0x0, auto"
      ];
      env = [
        "XCURSOR_SIZE,22"
      ];
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = "0";
        accel_profile = "flat";
        touchpad = {
          natural_scroll = false;
        };
      };
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 0;
        "col.active_border" = "rgba(88888888)";
        "col.inactive_border" = "rgba(00000088)";
        layout = "dwindle";
      };
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
        };
        shadow = {
          color = "rgba(00000099)";
        };
      };
      animations = {
        enabled = true;
        animation = [
          "border, 1, 2, default"
          "fade, 1, 4, default"
          "windows, 1, 3, default, popin 80%"
          "workspaces, 1, 2, default, slide"
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_status = "master";
      };
      gestures = {
        workspace_swipe = false;
      };
      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };
      cursor = {
        hide_on_key_press = true;
      };
      misc = {
        disable_hyprland_logo = true;
        focus_on_activate = true;
      };
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };
    };
  };
}
