{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkForce;

  httpPort = 3200;
  sshPort = 2222;
  domain = "git.${config.homelab.domain}";

in
{
  networking.firewall.allowedTCPPorts = [
    config.services.forgejo.settings.server.HTTP_PORT
    config.services.forgejo.settings.server.SSH_PORT
  ];

  catppuccin.forgejo = {
    enable = true;
    flavor = "mocha";
    accent = "pink";
  };

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database.type = mkForce "postgres";
    settings = {
      DEFAULT.APP_NAME = "forgejo";
      server = {
        DOMAIN = domain;
        ROOT_URL = "https://${domain}";
        HTTP_PORT = httpPort;
        START_SSH_SERVER = true;
        BUILTIN_SSH_SERVER_USER = "git";
        SSH_PORT = sshPort;
        SSH_LISTEN_PORT = sshPort;
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

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:${toString httpPort}
    '';
  };
}
