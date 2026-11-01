{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption mkSecret;

  cfg = config.casa.services.papra;
  rdomain = config.networking.domain;
in
{
  options.casa.services.papra = mkServiceOption "papra" {
    port = 1221;
    domain = "documents.${rdomain}";
  };

  config = mkIf cfg.enable {
    sops.secrets.papra = mkSecret {
      file = "papra";
      key = "env";
    };

    services.papra = {
      enable = true;
      environmentFiles = [ config.sops.secrets.papra.path ];
      environment = {
        NODE_ENV = "production";
        TZ = "America/Los_Angeles";
        APP_BASE_URL = "https://${cfg.domain}";
        SERVER_HOSTNAME = cfg.host;
        PORT = cfg.port;
        # Keep the data layout previously mounted at /app/app-data in the container.
        DATABASE_URL = "file:/var/lib/papra/db/db.sqlite";
        DOCUMENT_STORAGE_FILESYSTEM_ROOT = "/var/lib/papra/documents";
        PAPRA_CONFIG_DIR = "/var/lib/papra";
      };
    };

    systemd.tmpfiles.settings."10-papra" = {
      "/var/lib/papra/db".d = {
        mode = "0700";
        inherit (config.services.papra) user group;
      };
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
