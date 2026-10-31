{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  inherit (self.lib) mkServiceOption mkSecret;

  cfg = config.casa.services.miniflux;
  rdomain = config.networking.domain;
in
{
  options.casa.services.miniflux =
    mkServiceOption "miniflux" {
      port = 9124;
      domain = "rss.${rdomain}";
    }
    // {
      oidc = {
        clientId = mkOption {
          type = types.str;
          default = "78ac739b-232c-451a-aaa3-461ac0917102";
          description = "The Pocket ID client ID for Miniflux";
        };
        discoveryEndpoint = mkOption {
          type = types.str;
          default = "https://id.frahz.dev";
          description = "The OIDC issuer URL, without .well-known/openid-configuration";
        };
      };
    };

  config = mkIf cfg.enable {
    sops.secrets.miniflux = mkSecret {
      file = "miniflux";
      key = "env";
    };

    services.miniflux = {
      enable = true;
      createDatabaseLocally = true;
      adminCredentialsFile = config.sops.secrets.miniflux.path;
      config = {
        LISTEN_ADDR = "${cfg.host}:${toString cfg.port}";
        BASE_URL = "https://${cfg.domain}";
        HTTPS = "1";
        TRUSTED_REVERSE_PROXY_NETWORKS = "127.0.0.1/32,::1/128";

        OAUTH2_PROVIDER = "oidc";
        OAUTH2_OIDC_PROVIDER_NAME = "Pocket ID";
        OAUTH2_CLIENT_ID = cfg.oidc.clientId;
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = cfg.oidc.discoveryEndpoint;
        OAUTH2_REDIRECT_URL = "https://${cfg.domain}/oauth2/oidc/callback";
        OAUTH2_USER_CREATION = "0";

        DISABLE_LOCAL_AUTH = "1";

        CLEANUP_ARCHIVE_READ_DAYS = 90;
        CLEANUP_ARCHIVE_UNREAD_DAYS = -1;
      };
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
