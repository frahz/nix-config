{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf optionalAttrs removeSuffix;
  inherit (self.lib) mkServiceOption mkSecret;

  cfg = config.casa.services.linkding;
  rdomain = config.networking.domain;
  issuer = removeSuffix "/" cfg.oidc.discoveryEndpoint;
in
{
  options.casa.services.linkding = mkServiceOption "linkding" {
    port = 9090;
    domain = "links.${rdomain}";
    oidc.discoveryEndpoint = "https://${config.casa.services.pocket-id.domain}";
  };

  config = mkIf cfg.enable {
    sops.secrets.linkding = mkSecret {
      file = "linkding";
      key = "env";
    };

    services.linkding = {
      enable = true;
      address = cfg.host;
      inherit (cfg) port;
      dataDir = "${cfg.storagePath}/linkding";
      environmentFile = config.sops.secrets.linkding.path;
      settings = {
        TZ = config.time.timeZone;
        LD_ENABLE_OIDC = "True";
        LD_DISABLE_LOGIN_FORM = "True";
        LD_CSRF_TRUSTED_ORIGINS = "https://${cfg.domain}";

        # Let Django generate HTTPS callback URLs behind Caddy.
        UWSGI_ROUTE_IF = "equal:\${HTTP_X_FORWARDED_PROTO};https addvar:HTTPS=on";

        OIDC_OP_AUTHORIZATION_ENDPOINT = "${issuer}/authorize";
        OIDC_OP_TOKEN_ENDPOINT = "${issuer}/api/oidc/token";
        OIDC_OP_USER_ENDPOINT = "${issuer}/api/oidc/userinfo";
        OIDC_OP_JWKS_ENDPOINT = "${issuer}/.well-known/jwks.json";
      }
      // optionalAttrs (cfg.oidc.clientId != "") {
        OIDC_RP_CLIENT_ID = cfg.oidc.clientId;
      };
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
