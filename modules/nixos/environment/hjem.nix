{
  config,
  inputs',
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;

  cfg = config.casa.profiles.graphical;

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    wayfreeze --after-freeze-cmd 'grim -g "$(slurp)" - | wl-copy; killall wayfreeze'
  '';
  screenshot-edit = pkgs.writeShellScriptBin "screenshot-edit" ''
    wayfreeze &
    WAYFREEZE_PID=$!
    sleep 0.1
    FILENAME_IN=~/Pictures/Screenshots/satty-$(date "+%Y%m%d-%H:%M:%S").png
    grim -g "$(slurp)" "$FILENAME_IN"
    kill $WAYFREEZE_PID
    FILENAME_OUT=~/Pictures/Screenshots/satty-$(date "+%Y%m%d-%H:%M:%S").png
    satty --filename "$FILENAME_IN" --output-filename "$FILENAME_OUT" --early-exit --copy-command "wl-copy"
    rm "$FILENAME_IN"
  '';
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = builtins.attrValues {
        inherit (pkgs)
          bzmenu
          dconf
          feishin
          ffmpeg
          gnome-calculator
          grim
          hyprland-preview-share-picker
          hyprpicker
          iwmenu
          jellyfin-desktop
          libnotify
          nautilus
          newsflash
          obsidian
          pwvucontrol
          satty
          slurp
          wayfreeze
          wl-clipboard
          yt-dlp
          ;
        inherit screenshot screenshot-edit;

        hayase = inputs'.paquetes.packages.hayase;
      };

      xdg.mime-apps.default-applications = {
        "inode/directory" = singleton "org.gnome.Nautilus.desktop";
        "x-scheme-handler/discord" = singleton "vesktop.desktop";
        "x-scheme-handler/spotify" = singleton "spotify.desktop";
      };
    };
  };
}
