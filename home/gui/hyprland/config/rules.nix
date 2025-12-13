{ lib, ... }:
let
  inherit (lib) concatLists;
  pip = "class:^(firefox)$, title:^(Firefox|Picture-in-Picture)$";

  mkFloat = app: [
    "center(1), ${app}"
    "float, ${app}"
    "size 40% 60%, ${app}"
  ];
in
{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = concatLists [
      [
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
      ]

      (mkFloat "initialTitle:(Open Files)")
      (mkFloat "class:(com.saivert.pwvucontrol)")
      (mkFloat "initialTitle:(Bluetooth Devices)")
    ];
  };
}
