{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) mkKeyValueDefault;
  inherit (lib.lists) singleton;

  cfg = config.casa.profiles.graphical;
  user = config.hjem.users.frahz;

  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = mkKeyValueDefault { } " = ";
  };

  keyValue = pkgs.formats.keyValue keyValueSettings;
in
{
  config = lib.mkIf cfg.enable {
    services.dbus.packages = singleton pkgs.ghostty;

    hjem.users.frahz = {
      packages = singleton pkgs.ghostty;

      xdg.config.files = {
        "bat/config".text = lib.mkAfter ''
          --map-syntax "${user.xdg.config.files."ghostty/config".source}:Ghostty Config"
        '';
        "bat/syntaxes/ghostty.sublime-syntax".source =
          "${pkgs.ghostty}/share/bat/syntaxes/ghostty.sublime-syntax";
        "ghostty/config" = {
          generator = keyValue.generate "ghostty-config";
          value = {
            font-family = "Berkeley Mono";
            font-style = "SemiCondensed";
            font-style-bold = "SemiBold SemiCondensed";
            font-style-bold-italic = "SemiBold SemiCondensed Oblique";
            font-style-italic = "SemiCondensed Oblique";
            gtk-titlebar = false;
            theme = "Catppuccin Mocha";
            window-inherit-working-directory = false;
            window-padding-x = 4;
            window-padding-y = 4;
          };
        };
        "systemd/user/app-com.mitchellh.ghostty.service.d/overrides.conf".text = ''
          [Unit]
          X-SwitchMethod=keep-old
          X-Reload-Triggers=${user.xdg.config.files."ghostty/config".source}
        '';
      };

      systemd.packages = singleton pkgs.ghostty;
    };
  };
}
