{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption mkSecret;

  cfg = config.casa.services.pocket-id;
  rdomain = config.networking.domain;
in
{
  options.casa.services.pocket-id = mkServiceOption "pocket-id" {
    port = 9018;
    domain = "id.${rdomain}";
  };

  config = mkIf cfg.enable {
    sops.secrets.pocket-id-encryption-key = mkSecret {
      file = "pocket-id";
      key = "encryption-key";
    };

    services.pocket-id = {
      enable = true;
      dataDir = "${cfg.storagePath}/pocket-id";
      credentials = {
        ENCRYPTION_KEY = config.sops.secrets.pocket-id-encryption-key.path;
      };
      settings = {
        ANALYTICS_DISABLED = true;
        APP_URL = "https://${cfg.domain}";
        HOST = cfg.host;
        PORT = cfg.port;
        TRUST_PROXY = true;
      };
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
