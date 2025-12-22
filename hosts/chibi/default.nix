{
  self,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./services
  ];

  # Secrets
  sops.secrets = {
    raulyrs = { };
    linkwarden-secrets = {
      sopsFile = "${self}/secrets/linkwarden-secrets.yaml";
    };
  };

  services.raulyrs = {
    enable = true;
    environmentFile = config.sops.secrets.raulyrs.path;
  };

  casa = {
    profiles = {
      server.enable = true;
    };
    hardware = {
      cpu = "intel";
      gpu = "intel";
      enableHardwareAcceleration = true;
      capabilities = {
        bluetooth = true;
      };
    };
    system.bluetooth = {
      enable = true;
      experimental = true;
    };
    virtualisation.enable = true;
    networking.tailscale = {
      exitNode.enable = true;
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
    services = {
      samba = {
        enable = true;
        shares = {
          sharing = {
            path = "/mnt/kuki/sharing";
          };
          music = {
            path = "/mnt/kuki/music";
          };
        };
      };
    };
  };
}
