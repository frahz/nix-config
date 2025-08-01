{ lib, ... }:
{
  imports = [
    ./systemd.nix
    ./tailscale.nix
    ./wireless.nix
  ];

  networking = {
    useDHCP = lib.mkDefault true;

    # DNS
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      # wifi.backend = "iwd";
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
