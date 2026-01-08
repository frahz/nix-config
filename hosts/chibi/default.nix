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
        dataDir = "${cfg.storage}/containers/linkwarden/data";
        postgres.dataDir = "${cfg.storage}/containers/linkwarden/pg_data";
      };
      freshrss = {
        enable = true;
        configDir = "${cfg.storage}/containers/freshrss/config";
      };
    };
    services = {
      raulyrs.enable = true;
      samba = {
        enable = true;
        shares = {
          sharing.path = "${cfg.storage}/sharing";
          music.path = "${cfg.storage}/music";
        };
      };
    };
  };
}
