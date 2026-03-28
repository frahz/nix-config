{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  inherit (self.lib) mkServiceOption mkSecret;

  cfg = config.casa.services.papra;
  rdomain = config.networking.domain;
in
{
  options.casa.services.papra =
    mkServiceOption "papra" {
      port = 1221;
      domain = "documents.${rdomain}";
    }
    // {
      version = mkOption {
        type = types.str;
        default = "26.3.0-rootless";
        example = ''
          The most recent version can be found here:
          https://github.com/papra-hq/papra/pkgs/container/papra
        '';
        description = "The docker image version for papra service";
      };
    };

  config = mkIf cfg.enable {
    sops.secrets.papra = mkSecret {
      file = "papra";
      key = "env";
    };

    users.users.papra = {
      isSystemUser = true;
      group = "papra";
      home = "/var/lib/papra";
      createHome = false;
    };
    users.groups.papra = { };

    systemd.tmpfiles.rules = [
      "d /var/lib/papra 0750 papra papra -"
    ];

    virtualisation.oci-containers.containers.papra = {
      autoStart = true;
      image = "ghcr.io/papra-hq/papra:${cfg.version}";
      volumes = [
        "/var/lib/papra:/app/app-data"
      ];
      user = "${toString config.users.users.papra.uid}:${toString config.users.groups.papra.gid}";
      environmentFiles = [ config.sops.secrets.papra.path ];
      environment = {
        TZ = "America/Los_Angeles";
        APP_BASE_URL = "https://${cfg.domain}";
      };
      ports = [
        "${toString cfg.port}:1221"
      ];
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
