{config, ...}: {
  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/kuki/music";
      EnableInsightsCollector = false;
    };
    openFirewall = true;
  };

  sops.secrets.navidrome = {};
  systemd.services.navidrome.serviceConfig.EnvironmentFile = config.sops.secrets.navidrome.path;
}
