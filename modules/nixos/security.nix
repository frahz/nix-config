{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  security = {
    polkit.enable = true;

    soteria.enable = config.casa.profiles.graphical.enable;

    pam = mkIf config.casa.profiles.graphical.enable {
      services = {
        hyprlock = { };
        greetd = {
          enableGnomeKeyring = true;
          gnupg.enable = true;
        };
      };
    };
  };
}
