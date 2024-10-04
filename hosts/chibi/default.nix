{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./services
    ./hardware-configuration.nix
    ../../modules/containers/homarr.nix
    ../../modules/containers/linkwarden.nix
    ../../modules/containers/excalidraw.nix
    ../../modules/containers/freshrss.nix
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
  sops.secrets.raulyrs = {};

  # Services
  services = {
    sugoi.enable = true;

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    samba = {
      enable = true;
      settings = {
        "global" = {
          "workgroup" = "WORKGROUP";
          "server string" = "inari server";
          "server role" = "standalone server";
          "pam password change" = "yes";
          "map to guest" = "bad user";
          "usershare allow guests" = "yes";
        };
        "sharing" = {
          path = "/mnt/kuki/sharing";
          comment = "shared directory";
          browseable = "yes";
          "read only" = "no";
          "inherit permissions" = "yes";
        };
        "music" = {
          path = "/mnt/kuki/music";
          comment = "shared directory";
          browseable = "yes";
          "read only" = "no";
          "inherit permissions" = "yes";
        };
      };
    };
    raulyrs = {
      enable = true;
      environmentFile = config.sops.secrets.raulyrs.path;
    };
  };

  # Containers
  container = {
    homarr = {
      volumes = [
        "/mnt/kuki/containers/homarr/configs:/app/data/configs"
        "/mnt/kuki/containers/homarr/icons:/app/public/icons"
        "/mnt/kuki/containers/homarr/data:/data"
      ];
    };
    linkwarden = {
      volumes = [
        "/mnt/kuki/containers/linkwarden/data:/data/data"
      ];
      pg_volumes = [
        "/mnt/kuki/containers/linkwarden/pg_data:/var/lib/postgresql/data"
      ];
      env_files = [/mnt/kuki/containers/linkwarden/linkwarden.env];
    };
    freshrss = {
      volumes = [
        "/mnt/kuki/containers/freshrss/config:/config"
      ];
    };
  };
}
