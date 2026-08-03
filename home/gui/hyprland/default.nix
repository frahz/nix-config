{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
  toLua = lib.generators.toLua { };
in
{
  config = mkIf (cfg.profiles.graphical.enable && isLinux) {

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
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
      configType = "lua";
      extraConfig = ''
        local cursorSize = ${toLua (toString config.home.pointerCursor.size)}
        local fuzzel = ${toLua (lib.getExe config.programs.fuzzel.package)}
        local hyprlock = ${toLua (lib.getExe config.programs.hyprlock.package)}

      ''
        + builtins.readFile ./config.lua;
    };

    xdg.configFile."hypr/xdph.conf" = {
      text = ''
        screencopy {
          custom_picker_binary = ${lib.getExe pkgs.hyprland-preview-share-picker}
          allow_token_by_default = true
        }
      '';
    };
  };
}
