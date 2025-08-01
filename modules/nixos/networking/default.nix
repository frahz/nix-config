{ lib, config, ... }:
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
      inherit (config.casa.profiles.graphical) enable;
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
