{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf getExe';
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

    sudo = {
      extraRules = [
        {
          groups = [ "wheel" ];

          commands = [
            # try to make nixos-rebuild work without password
            {
              command = getExe' config.system.build.nixos-rebuild "nixos-rebuild";
              options = [ "NOPASSWD" ];
            }

            # allow reboot and shutdown without password
            {
              command = getExe' pkgs.systemd "systemctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = getExe' pkgs.systemd "reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = getExe' pkgs.systemd "shutdown";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}
