{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum;

  inherit (config.casa.networking) wirelessBackend;
in
{
  options.casa.networking.wirelessBackend = mkOption {
    type = enum [
      "iwd"
      "wpa_supplicant"
    ];
    default = "wpa_supplicant";
    description = ''
      Backend that will be used for wireless connections using either `networking.wireless`
      or `networking.networkmanager.wifi.backend`
      Defaults to wpa_supplicant until iwd is stable.
    '';
  };

  config = {
    # enable wireless database, it helps keeping wifi speedy
    hardware.wirelessRegulatoryDatabase = true;

    networking.wireless = {
      # wpa_supplicant
      enable = config.casa.profiles.graphical.enable && wirelessBackend == "wpa_supplicant";

      extraConfig = ''
        update_config=1
      '';

      iwd = {
        enable = wirelessBackend == "iwd";

        settings = {
          Settings = {
            AutoConnect = true;
          };

          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 300;
          };
        };
      };
    };
  };
}
