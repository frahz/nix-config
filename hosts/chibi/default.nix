{
  pkgs,
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
        storage = "/mnt/kuki";
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
    system = {
      boot = {
        # https://lore.kernel.org/linux-bluetooth/actZBr+wqcABY5mt@lan/T/#rd05678c4a124450ba8bf95ead213d27248a9de9b
        kernel = pkgs.linuxPackages_6_18;
      };
      bluetooth = {
        enable = false;
        experimental = true;
      };
    };
    virtualisation.enable = true;
    networking = {
      enable = true;
      interfaces."10-lan" = "enp1s0";
      tailscale = {
        exitNode.enable = true;
      };
    };
    containers = {
      linkwarden = {
        enable = true;
        dataDir = "${cfg.storage}/containers/linkwarden/data";
        postgres.dataDir = "${cfg.storage}/containers/linkwarden/pg_data";
      };
      freshrss = {
        enable = true;
        configDir = "${cfg.storage}/containers/freshrss/config";
      };
    };
    services = {
      adguardhome.enable = true;
      caddy.enable = true;
      forgejo.enable = true;
      glance.enable = true;
      home-assistant.enable = true;
      immich = {
        enable = true;
        storagePath = cfg.storage;
      };
      navidrome = {
        enable = true;
        storagePath = cfg.storage;
      };
      papra.enable = true;
      raulyrs.enable = true;
      samba = {
        enable = true;
        shares = {
          sharing.path = "${cfg.storage}/sharing";
          music.path = "${cfg.storage}/music";
        };
      };
      slskd.enable = true;
      sugoi.enable = true;
    };
  };
}
