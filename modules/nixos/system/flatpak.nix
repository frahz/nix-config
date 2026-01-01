{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    services.flatpak.enable = true;

    environment.systemPackages = [ pkgs.bazaar pkgs.warehouse ];
  };
}
