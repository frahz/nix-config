{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
in
{
  config = mkIf (cfg.profiles.graphical.enable && isLinux) {
    home.packages = with pkgs; [
      legendary-gl # epic games launcher
      (pkgs.prismlauncher.override {
        jdks = with pkgs; [
          temurin-bin-8 # TODO: Maybe replace when `jdk8` isn't broken
          jdk17
          jdk21
        ];
      })
      # disable for now: https://github.com/NixOS/nixpkgs/issues/458830
      # (lutris.override {
      #   extraPkgs = pkgs: [
      #     winetricks
      #     wineWowPackages.full
      #   ];
      # }) # alternative game launcher

      # emulators
      # dolphin-emu # general console

      winetricks # wine helper utility
    ];

    programs = {
      mangohud.enable = true;
    };
  };
}
