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

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) bazaar warehouse;
    };
  };
}
