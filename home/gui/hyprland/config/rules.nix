{ lib, ... }:
let
  inherit (lib) concatLists;
  satty = "match:class ^(com.gabm.satty)$";
  pip = "match:class ^(firefox)$, match:title ^(Firefox|Picture-in-Picture)$";

  mkFloat = app: [ "center on, float on, size (monitor_w * 0.4) (monitor_h * 0.6), ${app}" ];
in
{
  wayland.windowManager.hyprland.settings = {
    windowrule = concatLists [
      [
        "suppress_event maximize match:class .*"

        "float on, size (monitor_w * 0.4) (monitor_h * 0.6), min_size 600 400, ${satty}"
        "float on, pin on, keep_aspect_ratio on, ${pip}"

        "tile on, match:class ^(Jellyfin Media Player)$"

        "float on, match:class ^(org.gnome.Calculator)$"
        "float on, match:title ^(mdrop)$"
      ]

      (mkFloat "match:class (com.saivert.pwvucontrol)")
      (mkFloat "match:initial_title (Open Files)")
      (mkFloat "match:initial_title (Bluetooth Devices)")
    ];
  };
}
