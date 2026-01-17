{ config, ... }:
let
  inherit (config.casa.profiles.server) domain storage;

  address = "0.0.0.0";
  port = 4533;
in
{
  sops.secrets.navidrome = { };
  services.navidrome = {
    enable = true;
    settings = {
      Address = address;
      Port = port;
      MusicFolder = "${storage}/music";
      EnableInsightsCollector = false;
    };
    environmentFile = config.sops.secrets.navidrome.path;
    openFirewall = true;
  };

  services.caddy.virtualHosts."music.${domain}" = {
    extraConfig = ''
      reverse_proxy http://${address}:${toString port}
    '';
  };
}
