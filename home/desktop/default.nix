{
  inputs,
  pkgs,
  ...
}: let
  # patching jellyfin player to use xwayland because with normal wayland it looks weird
  jellyfin-media-player-wayland = pkgs.jellyfin-media-player.overrideAttrs (prevAttrs: {
    nativeBuildInputs =
      (prevAttrs.nativeBuildInputs or [])
      ++ [pkgs.makeBinaryWrapper];

    postInstall =
      (prevAttrs.postInstall or "")
      + ''
        wrapProgram $out/bin/jellyfinmediaplayer --set QT_QPA_PLATFORM xcb
      '';
  });
in {
  imports = [
    ./programs
    ./services
    ./utils
    ./hyprland
    ./hyprland/programs/hyprlock.nix
    ./hyprland/services/hyprpaper.nix
    ./hyprland/services/hypridle.nix
  ];

  home.packages = with pkgs; [
    anki-bin
    dconf
    xfce.thunar # file manager for now
    gimp
    ffmpeg
    jellyfin-media-player-wayland
    pavucontrol
    hyprpicker
    miru
    vesktop
    obs-studio
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 18;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["thunar.desktop"];
        "x-scheme-handler/spotify" = ["spotify.desktop"];
        "x-scheme-handler/discord" = ["vesktop.desktop"];
      };
    };
  };
}
