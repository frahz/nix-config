{ lib, pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./wayland.nix
  ];

  console = {
    enable = lib.mkDefault true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-d24n.psf.gz";
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
}
