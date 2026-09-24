{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  casa = {
    profiles = {
      server = {
        enable = true;
        domain = "frahz.dev";
        storage = "/var/lib";
      };
      oracle.enable = true;
    };
    hardware = {
      cpu = null;
      gpu = null;
    };
    system.boot.kernel = pkgs.linuxPackages_6_18;
    networking = {
      enable = true;
      fail2ban.enable = true;
      interfaces."10-lan" = "enp0s6";
      tailscale = { };
    };
    services = {
      caddy.enable = true;
      pocket-id.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
