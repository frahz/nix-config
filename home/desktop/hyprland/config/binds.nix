{
  lib,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, Return, exec, ghostty"
      "$mainMod, Q, killactive,"
      "$mainMod, V, togglefloating,"
      "$mainMod, F, fullscreen,"
      "$mainMod, M, exit,"
      "$mainMod, P, pseudo," # dwindle
      "$mainMod, J, togglesplit," # dwindle

      "Alt, Space, exec, anyrun"
      "$mainMod, B, exec, killall .waybar-wrapped && waybar &"
      "$mainMod, L, exec, ${lib.getExe config.programs.hyprlock.package}"
      "$mainMod, Escape, exec, powermenu"

      # browser
      "$mainMod,       W, exec, firefox"
      "$mainMod Shift, W, exec, firefox --private-window"

      "$mainMod, E, exec, thunar"
      "$mainMod Shift, C, exec, pkill hyprpicker || hyprpicker --autocopy --no-fancy --format=hex"

      # screenshot utilities
      "$mainMod      , S, exec, screenshot"
      "$mainMod Shift, S, exec, screenshot-edit"

      # Good ol Alt+Tab
      "Alt,       Tab, cyclenext"
      "Alt Shift, Tab, cyclenext, prev"

      # Move focus with mainMod + arrow keys
      "$mainMod, left,  movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up,    movefocus, u"
      "$mainMod, down,  movefocus, d"

      # Move windows with mainMod + arrow keys
      "$mainMod Shift, left,  swapwindow, l"
      "$mainMod Shift, right, swapwindow, r"
      "$mainMod Shift, up,    swapwindow, u"
      "$mainMod Shift, down,  swapwindow, d"

      # Window Resizing                      X   Y
      "$mainMod Ctrl, left,  resizeactive, -60   0"
      "$mainMod Ctrl, right, resizeactive,  60   0"
      "$mainMod Ctrl, up,    resizeactive,   0 -60"
      "$mainMod Ctrl, down,  resizeactive,   0  60"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
