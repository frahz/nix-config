{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    services = {
      gnome = {
        gnome-keyring.enable = true;
      };
    };
  };
}
