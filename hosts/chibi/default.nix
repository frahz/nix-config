{
  self,
  config,
  ...
}:
{
  imports = [
    ./services
    ./hardware-configuration.nix
  ];

  hardware = {
    bluetooth.enable = true;
    # Hardware Accelerated Video
    graphics = {
      enable = true;
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
  casa = {
    hardware = {
      cpu = "intel";
      gpu = "intel";
    };
    containers = {
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
  };
}
