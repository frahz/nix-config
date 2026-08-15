{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  cfg = config.casa.profiles.graphical;
  sources = config.catppuccin.sources;
  mpv = pkgs.mpv.override { scripts = singleton pkgs.mpvScripts.modernx; };
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = builtins.attrValues {
        inherit (pkgs) imv zathura;
        inherit mpv;
      };

      xdg.config.files = {
        # TODO: fix
        # "imv/config".source = "${sources.imv}/mocha.config";
        "mpv/mpv.conf".text = ''
          border=no
          include=${sources.mpv}/mocha/pink.conf
          osc=no
        '';
        "zathura/zathurarc".text = ''
          include ${sources.zathura}/catppuccin-mocha
        '';
      };

      xdg.mime-apps.default-applications = {
        "application/pdf" = singleton "org.pwmt.zathura.desktop";
        "audio/*" = singleton "mpv.desktop";
        "image/apng" = singleton "imv.desktop";
        "image/avif" = singleton "imv.desktop";
        "image/gif" = singleton "imv.desktop";
        "image/jpeg" = singleton "imv.desktop";
        "image/png" = singleton "imv.desktop";
        "image/svg+xml" = singleton "imv.desktop";
        "image/webp" = singleton "imv.desktop";
        "video/*" = singleton "mpv.desktop";
      };
    };
  };
}
