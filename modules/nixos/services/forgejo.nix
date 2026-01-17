{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.forgejo;
  rdomain = config.networking.domain;
in
{
  options.casa.services.forgejo = mkServiceOption "forgejo" {
    port = 3200;
    domain = "git.${rdomain}";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      config.services.forgejo.settings.server.HTTP_PORT
      config.services.forgejo.settings.server.SSH_PORT
    ];

    catppuccin.forgejo = {
      enable = true;
      flavor = "mocha";
      accent = "pink";
    };
    services = {
      forgejo = {
        enable = true;
        package = pkgs.forgejo;
        database.type = mkForce "postgres";
        settings = {
          DEFAULT.APP_NAME = "forgejo";
          server = {
            DOMAIN = cfg.domain;
            ROOT_URL = "https://${cfg.domain}";
            HTTP_PORT = cfg.port;
            SSH_PORT = lib.head config.services.openssh.ports;
          };
          service = {
            DISABLE_REGISTRATION = true;
          };
          session = {
            COOKIE_SECURE = true;
            # Sessions last for 1 weeks
            SESSION_LIFE_TIME = 86400 * 7;
          };
        };
      };

      caddy.virtualHosts.${cfg.domain} = {
        extraConfig = ''
          reverse_proxy http://localhost:${toString cfg.port}
        '';
      };
    };
  };
}
