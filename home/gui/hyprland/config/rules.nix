_:
let
  pip = "class:^(firefox)$, title:^(Firefox|Picture-in-Picture)$";
in
{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "suppressevent maximize, class:.*" # You'll probably like this.

      # Firefox PiP
      "float, ${pip}"
      "pin, ${pip}"
      "keepaspectratio, ${pip}"

      # Jellyfin running in XWayland
      "tile, class:^(Jellyfin Media Player)$"

      "float, class:^(com.gabm.satty)$"
      "size >40% >60%, class:^(com.gabm.satty)$"
      "minsize 600 400, class:^(com.gabm.satty)$"

      "float, class:^(org.gnome.Calculator)$"
      "float, title:^(mdrop)$"

      "center(1), initialTitle:(Open Files)"
      "float, initialTitle:(Open Files)"
      "size 40% 60%, initialTitle:(Open Files)"

      "center(1), class:^(com.saivert.pwvucontrol)$"
      "float, class:^(com.saivert.pwvucontrol)$"
      "size 40% 60%, class:^(com.saivert.pwvucontrol)$"

      "center(1), initialTitle:(Bluetooth Devices)"
      "float, initialTitle:(Bluetooth Devices)"
      "size 40% 60%, initialTitle:(Bluetooth Devices)"
    ];
  };
}
