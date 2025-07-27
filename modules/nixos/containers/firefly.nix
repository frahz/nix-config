{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.container.firefly;
in
{
  options.container.firefly = {
    volumes = mkOption {
      type = with types; listOf str;
    };
    db_volumes = mkOption {
      type = with types; listOf str;
    };
    app_env = mkOption {
      type = with types; listOf path;
    };
    db_env = mkOption {
      type = with types; listOf path;
    };
    importer_env = mkOption {
      type = with types; listOf path;
    };
  };

  config = {
    networking.firewall = {
      allowedTCPPorts = [
        4040
        4041
      ];
      allowedUDPPorts = [
        4040
        4041
      ];
    };

    systemd.services.init-firefly-network = {
      description = "Create bridge for firefly";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";
      script =
        let
          docker = config.virtualisation.oci-containers.backend;
          dockerBin = "${pkgs.${docker}}/bin/${docker}";
        in
        ''
          ${dockerBin} network inspect firefly_iii >/dev/null 2>&1 || ${dockerBin} network create firefly_iii
        '';
    };

    virtualisation.oci-containers.containers = {
      firefly = {
        autoStart = true;
        image = "fireflyiii/core:latest";
        inherit (cfg) volumes;
        environment = {
          TZ = "America/Los_Angeles";
        };
        environmentFiles = cfg.app_env;
        ports = [
          "4040:8080"
        ];
        dependsOn = [ "firefly_db" ];
        extraOptions = [ "--network=firefly_iii" ];
      };

      firefly_db = {
        autoStart = true;
        image = "mariadb";
        volumes = cfg.db_volumes;
        environment = {
          TZ = "America/Los_Angeles";
        };
        environmentFiles = cfg.db_env;
        extraOptions = [ "--network=firefly_iii" ];
      };

      firefly_importer = {
        autoStart = true;
        image = "fireflyiii/data-importer:latest";
        environmentFiles = cfg.importer_env;
        ports = [
          "4041:8080"
        ];
        extraOptions = [ "--network=firefly_iii" ];
      };
    };
  };
}
