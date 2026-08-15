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
    packages = singleton pkgs.btop;
    xdg.config.files = {
      "btop/btop.conf".text = ''color_theme = "catppuccin_mocha.theme"'';
      "btop/themes/catppuccin_mocha.theme".source = "${sources.btop}/catppuccin_mocha.theme";
    };
  };
}
