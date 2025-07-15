{ pkgs, ... }:
{
  home.packages = with pkgs; [
    legendary-gl # epic games launcher
    mangohud # fps counter & vulkan overlay
    (lutris.override {
      extraPkgs = pkgs: [
        winetricks
        wineWowPackages.full
      ];
    }) # alternative game launcher

    # emulators
    # dolphin-emu # general console

    # runtime
    dotnet-runtime_6 # for running terraria manually, from binary
    mono # general dotnet apps
    winetricks # wine helper utility
  ];
}
