{
  inputs,
  pkgs,
  ...
}: {
  imports = [./services/greetd.nix];

  environment = {
    systemPackages = with pkgs; [
      wayland
      glib
      grim
      slurp
      satty
      wl-clipboard
      wlr-randr
    ];
    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      MOZ_ENABLE_WAYLAND = "1";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      NIXOS_OZONE_WL = "1";
      EDITOR = "nvim";
      TERMINAL = "alacritty";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      inputs.xdg-portal-hyprland.packages.${pkgs.system}.default
    ];
    config.common.default = "*";
  };
}
