{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  home = config.users.users.frahz.home;
in
{
  hjem.users.frahz = {
    packages = singleton pkgs.wget;
    xdg.config.files = {
      "npm/npmrc".text = ''
        prefix=${home}/.local/share/npm
        cache=${home}/.cache/npm
        init-module=${home}/.config/npm/config/npm-init.js
      '';
      "wget/wgetrc".text = "hsts-file = ${home}/.local/share/wget/hsts\n";
    };
  };
}
