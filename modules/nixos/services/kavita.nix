{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption mkSecret;

  cfg = config.casa.services.kavita;
  inherit (config.casa.profiles.server) storage;

  rdomain = config.networking.domain;
in
{
  options.casa.services.kavita = mkServiceOption "kavita" {
    host = "0.0.0.0";
    port = 5000;
    domain = "kavita.${rdomain}";
  };

  config = mkIf cfg.enable {
    sops.secrets.kavita = mkSecret {
      file = "kavita";
      key = "token";
    };

    users.users.kavita.extraGroups = [ "media" ];

    services.kavita = {
      enable = true;
      dataDir = "${storage}/containers/kavita";
      tokenKeyFile = config.sops.secrets.kavita.path;
      settings.Port = cfg.port;
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
