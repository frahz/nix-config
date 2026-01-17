{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.containers.linkwarden;
  rdomain = config.networking.domain;
in
{
  options.casa.containers.linkwarden =
    mkServiceOption "linkwarden" {
      port = 3000;
      domain = "lw.${rdomain}";
    }
    // {
      version = mkOption {
        type = types.str;
        default = "v2.9.3";
        example = ''
          The most recent version can be found here:
          https://github.com/linkwarden/linkwarden/pkgs/container/linkwarden
        '';
        description = "The docker image version for linkwarden service";
      };
      dataDir = mkOption {
        type = types.path;
        description = ''
          Directory for configuration for linkwarden service;
        '';
      };
      postgres = {
        version = mkOption {
          type = types.str;
          default = "16-alpine";
          example = ''
            The most recent version can be found here:
            https://github.com/linkwarden/linkwarden/pkgs/container/linkwarden
          '';
          description = ''
            The docker image version for postgres instance used by linkwarden service.
          '';
        };
        dataDir = mkOption {
          type = types.path;
          description = ''
            Data directory for postgresql instance used by linkwarden service.
          '';
        };
      };
      network = mkOption {
        type = types.str;
        default = "linkwarden-br";
        description = "Network name for linkwarden containers";
      };
    };

  config = mkIf cfg.enable {
    sops.secrets.linkwarden-secrets = {
      sopsFile = "${self}/secrets/linkwarden-secrets.yaml";
    };

    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.init-linkwarden-network = {
      description = "Create bridge for linkwarden";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";
      script =
        let
          docker = config.virtualisation.oci-containers.backend;
          dockerBin = "${pkgs.${docker}}/bin/${docker}";
        in
        ''
          ${dockerBin} network inspect ${cfg.network} >/dev/null 2>&1 || ${dockerBin} network create ${cfg.network}
        '';
    };

    virtualisation.oci-containers.containers.linkwarden = {
      autoStart = true;
      image = "ghcr.io/linkwarden/linkwarden:${cfg.version}";
      volumes = [
        "${cfg.dataDir}:/data/data"
      ];
      environment = {
        TZ = "America/Los_Angeles";
      };
      environmentFiles = [
        config.sops.secrets.linkwarden-secrets.path
      ];
      ports = [
        "${toString cfg.port}:3000"
      ];
      dependsOn = [ "linkwarden_pg" ];
      networks = [ cfg.network ];
    };

    virtualisation.oci-containers.containers.linkwarden_pg = {
      autoStart = true;
      image = "postgres:${cfg.postgres.version}";
      volumes = [
        "${cfg.postgres.dataDir}:/var/lib/postgresql/data"
      ];
      environment = {
        TZ = "America/Los_Angeles";
      };
      environmentFiles = [
        config.sops.secrets.linkwarden-secrets.path
      ];
      networks = [ cfg.network ];
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
