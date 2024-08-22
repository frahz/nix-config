_: let
  pip = "class:^(firefox)$, title:^(Firefox|Picture-in-Picture)$";
in {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "suppressevent maximize, class:.*" # You'll probably like this.
      # "float, class:(mpv)"

      # Firefox PiP
      "float, ${pip}"
      "keepaspectratio, ${pip}"

      # Jellyfin running in XWayland
      "tile, class:^(Jellyfin Media Player)$"
    ];
  };
}
