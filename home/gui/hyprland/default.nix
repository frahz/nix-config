{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
in
{
  imports = [
    ./config/binds.nix
    ./config/general.nix
    ./config/rules.nix
  ];

  config = mkIf (cfg.profiles.graphical.enable && isLinux) {

    wayland.windowManager.hyprland = {
      enable = true;
      # TODO: move to uwsm cuz that seems to be a thing now?
      systemd = {
        enable = true;
        variables = [ "--all" ];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
      xwayland.enable = true;
    };

    xdg.configFile."hypr/xdph.conf" = {
      text = ''
        screencopy {
          custom_picker_binary = ${pkgs.hyprland-preview-share-picker}/bin/hyprland-preview-share-picker
          allow_token_by_default = true
        }
      '';
    };
  };
}
