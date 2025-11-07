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
      mangohud # fps counter & vulkan overlay
      # disable for now: https://github.com/NixOS/nixpkgs/issues/458830
      # (lutris.override {
      #   extraPkgs = pkgs: [
      #     winetricks
      #     wineWowPackages.full
      #   ];
      # }) # alternative game launcher

      # emulators
      # dolphin-emu # general console

      # runtime
      # mono # general dotnet apps
      winetricks # wine helper utility
    ];
  };
}
