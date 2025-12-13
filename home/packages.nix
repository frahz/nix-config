{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) optionals concatLists;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
in
{

  home.packages =
    with pkgs;
    concatLists [
      [
        yt-dlp
        unzip
        unrar
        dig
        jq
        tokei
        wget
        killall
      ]

      (optionals cfg.profiles.graphical.enable [
        anki-bin
        ffmpeg

        vesktop
        obs-studio
        obsidian
        typst
        libnotify
      ])

      (optionals (cfg.profiles.graphical.enable && isLinux) [
        pwvucontrol
        newsflash
        dconf
        xfce.thunar # file manager for now
        # feishin
        gimp
        gnome-calculator
        grim
        slurp
        satty
        wayfreeze
        wl-clipboard
        (pkgs.writeShellScriptBin "screenshot" ''
          wayfreeze --after-freeze-cmd 'grim -g "$(slurp)" - | wl-copy; killall wayfreeze'
        '')
        (pkgs.writeShellScriptBin "screenshot-edit" ''
          wayfreeze &
          WAYFREEZE_PID=$!
          sleep 0.1
          FILENAME_IN=~/Pictures/Screenshots/satty-$(date "+%Y%m%d-%H:%M:%S").png
          grim -g "$(slurp)" "$FILENAME_IN"
          kill $WAYFREEZE_PID
          FILENAME_OUT=~/Pictures/Screenshots/satty-$(date "+%Y%m%d-%H:%M:%S").png
          satty --filename "$FILENAME_IN" --output-filename "$FILENAME_OUT" --early-exit --copy-command "wl-copy"
          rm "$FILENAME_IN"
        '')
        hayase
        hyprpicker
        hyprland-preview-share-picker
        iwmenu
        bzmenu
      ])
    ];

}
