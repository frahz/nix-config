{
  config,
  ...
}:
let
  cfg = config.casa.profiles.server;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  casa = {
    profiles = {
      server = {
        enable = true;
        storage = "/mnt/mizu";
      };
    };
    hardware = {
      cpu = "intel";
      gpu = "intel";
      enableHardwareAcceleration = true;
      capabilities = {
        bluetooth = true;
      };
    };
    networking = {
      enable = true;
      interfaces."10-lan" = "enp0s31f6";
    };
    services = {
      caddy.enable = true;
      media.enable = true;
      nemui.enable = true;
      scrutiny.enable = true;
    };
    virtualisation.enable = true;
    containers = {
      torrent = {
        enable = true;
        qbittorrent = {
          configDir = "${cfg.storage}/containers/qbittorrent/config";
          torrentDir = "${cfg.storage}/torrents";
        };
        gluetun = {
          configDir = "${cfg.storage}/containers/gluetun/config";
          serversFile = "${cfg.storage}/containers/gluetun/servers.json";
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
