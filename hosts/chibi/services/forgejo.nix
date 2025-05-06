{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkAfter mkForce;
  inherit (lib.strings) removePrefix removeSuffix;

  httpPort = 3200;
  sshPort = 2222;
  domain = "git.${config.homelab.domain}";

  # stole from https://github.com/isabelroses/dotfiles/blob/main/modules/nixos/services/selfhosted/forgejo.nix
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.1/catppuccin-gitea.tar.gz";
    hash = "sha256-et5luA3SI7iOcEIQ3CVIu0+eiLs8C/8mOitYlWQa/uI=";
    stripRoot = false;
  };
in {
  networking.firewall.allowedTCPPorts = [
    config.services.forgejo.settings.server.HTTP_PORT
    config.services.forgejo.settings.server.SSH_PORT
  ];

  systemd.services.forgejo = {
    preStart = let
      inherit (config.services.forgejo) stateDir;
    in
      mkAfter ''
        rm -rf ${stateDir}/custom/public/assets
        mkdir -p ${stateDir}/custom/public/assets
        ln -sf ${theme} ${stateDir}/custom/public/assets/css
      '';
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
      ui = {
        DEFAULT_THEME = "catppuccin-mocha-pink";
        THEMES = builtins.concatStringsSep "," (
          ["auto,forgejo-auto,forgejo-dark,forgejo-light,arc-gree,gitea"]
          ++ (map (name: removePrefix "theme-" (removeSuffix ".css" name)) (
            # IFD, https://github.com/catppuccin/nix/pull/179
            builtins.attrNames (builtins.readDir theme)
          ))
        );
      };
    };
  };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:${toString httpPort}
    '';
  };
}
