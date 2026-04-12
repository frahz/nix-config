{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption mkSecret;
  inherit (config.casa.profiles.server) storage;

  cfg = config.casa.services.slskd;
  rdomain = config.networking.domain;
in
{
  options.casa.services.slskd = mkServiceOption "slskd" {
    host = "0.0.0.0";
    port = 3018;
    domain = "soulseek.${rdomain}";
    storagePath = storage;
  };

  config = mkIf cfg.enable {
    sops.secrets.slskd = mkSecret {
      file = "slskd";
      key = "env";
    };
    services.slskd = {
      enable = true;
      openFirewall = true;
      group = "users";

      environmentFile = config.sops.secrets.slskd.path;

      settings = {
        web = {
          inherit (cfg) port;
          ip_address = cfg.host;
        };

        permissions.file.mode = 775;

        directories = {
          incomplete = "${cfg.storagePath}/downloads/music";
          downloads = "${cfg.storagePath}/music";
        };

        # shares.directories = [ "${cfg.storagePath}/music" ];
      };

    };
    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
