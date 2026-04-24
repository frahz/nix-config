{ lib, pkgs, ... }:
let
  inherit (lib) mkForce;
in
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

  documentation = {
    enable = mkForce false;
    dev.enable = mkForce false;
    doc.enable = mkForce false;
    info.enable = mkForce false;
    nixos.enable = mkForce false;

    man = {
      enable = mkForce false;
      cache.enable = mkForce false;
      man-db.enable = mkForce false;
      mandoc.enable = mkForce false;
    };
  };
}
