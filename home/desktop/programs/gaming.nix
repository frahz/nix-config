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
    # mono # general dotnet apps
    winetricks # wine helper utility
  ];
}
