{ lib, config, ... }:
let
  inherit (lib) mkDefault mkIf;
in
{
  imports = [
    ./mullvad.nix
    ./systemd.nix
    ./tailscale.nix
    ./wireless.nix
  ];

  networking = {
    useDHCP = mkDefault true;

    # DNS
    nameservers = mkIf (!(config ? wsl)) [
      "1.1.1.1"
      "1.0.0.1"
    ];

    networkmanager = {
      inherit (config.casa.profiles.graphical) enable;
      dns = "systemd-resolved";
      wifi.backend = config.casa.networking.wirelessBackend;
    };
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
}
