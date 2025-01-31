_: let
  pip = "class:^(firefox)$, title:^(Firefox|Picture-in-Picture)$";
in {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "suppressevent maximize, class:.*" # You'll probably like this.
      # "float, class:(mpv)"

      # Firefox PiP
      "float, ${pip}"
      "pin, ${pip}"
      "keepaspectratio, ${pip}"

      # Jellyfin running in XWayland
      "tile, class:^(Jellyfin Media Player)$"

      "minsize 600 400, class:^(com.gabm.satty)$"
    ];
  };
}
