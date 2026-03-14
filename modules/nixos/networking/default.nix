{ lib, config, ... }:
let
  inherit (lib) mkForce mkIf;
in
{
  imports = [
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

    # TODO: define networkd networks manually for server down the line
    networkmanager = {
      enable = true;
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
