{pkgs, ...}: {
  imports = [
    ./config/binds.nix
    ./config/general.nix
    ./config/rules.nix
  ];

  home.packages = with pkgs; [
    grim
    hyprland-preview-share-picker
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
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # TODO: move to uwsm cuz that seems to be a thing now?
    systemd = {
      enable = true;
      variables = ["--all"];
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
}
