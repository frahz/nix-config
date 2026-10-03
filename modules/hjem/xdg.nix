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
      "user-dirs.dirs".text = ''
        XDG_DESKTOP_DIR="$HOME/Desktop"
        XDG_DOCUMENTS_DIR="$HOME/Documents"
        XDG_DOWNLOAD_DIR="$HOME/Downloads"
        XDG_PUBLICSHARE_DIR="$HOME/Public"
        XDG_TEMPLATES_DIR="$HOME/Templates"
        XDG_MUSIC_DIR="$HOME/Music"
        XDG_PICTURES_DIR="$HOME/Pictures"
        XDG_VIDEOS_DIR="$HOME/Videos"
      '';
    };
  };
  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
}
