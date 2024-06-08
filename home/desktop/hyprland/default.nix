_: {
  imports = [./config/binds.nix ./config/general.nix];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
  };
}
