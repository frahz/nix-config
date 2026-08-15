{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  sources = config.catppuccin.sources;
in
{
  hjem.users.frahz = {
    packages = singleton pkgs.bat;
    xdg.config.files = {
      "bat/config".text = ''--theme="Catppuccin Mocha"'';
      "bat/themes/Catppuccin Mocha.tmTheme".source = "${sources.bat}/Catppuccin Mocha.tmTheme";
    };
  };
}
