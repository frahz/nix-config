_: {
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, Return, exec, alacritty"
      "$mainMod, Q, killactive,"
      "$mainMod, V, togglefloating,"
      "$mainMod, F, fullscreen,"
    ];
  };
}
