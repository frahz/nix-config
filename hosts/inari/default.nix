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
    ../../modules/containers/torrent.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = 5;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    swraid = {
      enable = true;
      mdadmConf = ''
        HOMEHOST <system>
        MAILADDR root
        ARRAY /dev/md/yanai:0 metadata=1.2 name=yanai:0 UUID=dbb1c332:9130b9ad:e2d8640b:7a533ded
      '';
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware = {
    graphics = {
      # Hardware Accelerated Video
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver # previously vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
        vpl-gpu-rt
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    hugo
  ];

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

  # Containers
  container = {
    torrent = {
      qb_volumes = [
        "/mnt/mizu/torrents:/torrents"
        "/mnt/mizu/containers/qbittorrent/config:/config"
      ];
      gluetun_volumes = [
        "/mnt/mizu/containers/gluetun/config:/config"
        "/mnt/mizu/containers/gluetun/servers.json:/gluetun/servers.json"
      ];
      vpn_info_file = config.sops.secrets.gluetun.path;
    };
  };
}
