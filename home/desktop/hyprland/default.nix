{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./config/binds.nix
    ./config/general.nix
    ./config/rules.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp
    satty
    wl-clipboard
    (pkgs.writeShellScriptBin "screenshot" ''
      grim -g "$(slurp)" - | wl-copy
    '')
    (pkgs.writeShellScriptBin "screenshot-edit" ''
      grim -g "$(slurp)" - | satty -f - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png --early-exit --copy-command 'wl-copy'
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
}
