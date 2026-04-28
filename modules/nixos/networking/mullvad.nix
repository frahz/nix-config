{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkForce mkIf;
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    # Mullvad enable support: https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/10?u=lion
    networking.resolvconf.enable = mkForce false;
  };
}
