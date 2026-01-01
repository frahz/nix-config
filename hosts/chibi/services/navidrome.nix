{ config, ... }:
let
  inherit (config.casa.profiles.server) domain storage;

  address = "0.0.0.0";
  port = 4533;
in
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = address;
      Port = port;
      MusicFolder = "${storage}/music";
      EnableInsightsCollector = false;
    };
    openFirewall = true;
  };

  sops.secrets.navidrome = { };
  systemd.services.navidrome.serviceConfig.EnvironmentFile = config.sops.secrets.navidrome.path;

  services.caddy.virtualHosts."music.${domain}" = {
    extraConfig = ''
      reverse_proxy http://${address}:${toString port}
    '';
  };
}
