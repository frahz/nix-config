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
      interfaces."10-lan" = "enp0s6";
      tailscale = { };
    };
  };

  system.stateVersion = "26.05";
}
