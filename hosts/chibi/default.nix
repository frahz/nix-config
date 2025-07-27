{
  self,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./services
    ./hardware-configuration.nix
    ../../modules/containers
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
    bluetooth.enable = true;
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
  sops.secrets = {
    raulyrs = { };
    "linkwarden-secrets" = {
      sopsFile = "${self}/secrets/linkwarden-secrets.yaml";
    };
  };

  # Services
  services = {
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
    linkwarden = {
      enable = true;
      dataDir = "/mnt/kuki/containers/linkwarden/data";
      postgres = {
        dataDir = "/mnt/kuki/containers/linkwarden/pg_data";
      };
      environmentFile = config.sops.secrets.linkwarden-secrets.path;
    };
    freshrss = {
      enable = true;
      configDir = "/mnt/kuki/containers/freshrss/config";
    };
  };
}
