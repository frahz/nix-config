{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption mkSecret;

  cfg = config.casa.services.navidrome;
  rdomain = config.networking.domain;
in
{
  options.casa.services.navidrome = mkServiceOption "navidrome" {
    port = 4533;
    domain = "music.${rdomain}";
  };

  config = mkIf cfg.enable {
    sops.secrets.navidrome = mkSecret {
      file = "navidrome";
      key = "env";
    };
    services.navidrome = {
      enable = true;
      settings = {
        Address = cfg.host;
        Port = cfg.port;
        MusicFolder = "${cfg.storagePath}/music";
        EnableInsightsCollector = false;
      };
      environmentFile = config.sops.secrets.navidrome.path;
    };
    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
