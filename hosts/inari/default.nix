{
  config,
  lib,
  pkgs,
  ...
}:
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

  hardware = {
    graphics = {
      # Hardware Accelerated Video
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
        vpl-gpu-rt
      ];
    };
  };

  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  # Secrets
  sops.secrets = {
    tsauth-inari = { };
    gluetun = { };
    gitea = { };
  };

  # Services
  services = {
    tailscale-autoconnect = {
      enable = true;
      authKeyFile = config.sops.secrets.tsauth-inari.path;
    };

    nemui.enable = true;
  };

  casa = {
    hardware = {
      cpu = "intel";
      gpu = "intel";
    };

    # Containers
    containers = {
      torrent = {
        enable = true;
        qbittorrent = {
          configDir = "/mnt/mizu/containers/qbittorrent/config";
          torrentDir = "/mnt/mizu/torrents";
        };
        gluetun = {
          configDir = "/mnt/mizu/containers/gluetun/config";
          serversFile = "/mnt/mizu/containers/gluetun/servers.json";
          environmentFile = config.sops.secrets.gluetun.path;
        };
      };
    };
  };
}
