{ lib, config, ... }:
let
  inherit (lib) mkForce mkIf;
in
{
  imports = [
    ./interfaces.nix
    ./mullvad.nix
    ./systemd.nix
    ./tailscale.nix
    ./wireless.nix
  ];

  networking = {
    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    # DNS
    nameservers = mkIf (!(config ? wsl)) [
      "1.1.1.1"
      "1.0.0.1"
    ];

    networkmanager = {
      enable = !config.casa.profiles.server.enable;
      dns = "systemd-resolved";
      wifi.backend = "iwd";
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
