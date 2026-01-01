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
    ./services
  ];

  boot = {
    swraid = {
      enable = true;
      mdadmConf = ''
        HOMEHOST <system>
        MAILADDR root
        ARRAY /dev/md/yanai:0 metadata=1.2 name=yanai:0 UUID=dbb1c332:9130b9ad:e2d8640b:7a533ded
      '';
    };
  };

  # Secrets
  sops.secrets = {
    tsauth-inari = { };
    gluetun = { };
    gitea = { };
  };

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
    services = {
      tailscale-autoconnect = {
        enable = true;
        authKeyFile = config.sops.secrets.tsauth-inari.path;
      };

      nemui.enable = true;
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
          environmentFile = config.sops.secrets.gluetun.path;
        };
      };
    };
  };
}
