{ config, lib, pkgs, ... }:

with lib;
let
    cfg = config.container.gitea;
in
{
    options.container.gitea = {
        gitea_volumes = mkOption {
            type = with types; listOf str;
        };
        pg_volumes = mkOption {
            type = with types; listOf str;
        };
        runner_volumes = mkOption {
            type = with types; listOf str;
        };
        env_file = mkOption {
            type = with types; str;
        };
    };

    config = {
        networking.firewall = {
            allowedTCPPorts = [ 3000 2221 ];
            allowedUDPPorts = [ 3000 2221 ];
        };

        systemd.services.init-gitea-network = {
            description = "Create bridge for gitea";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            serviceConfig.Type = "oneshot";
            script = let
                docker = config.virtualisation.oci-containers.backend;
                dockerBin = "${pkgs.${docker}}/bin/${docker}";
            in ''
                ${dockerBin} network inspect gitea >/dev/null 2>&1 || ${dockerBin} network create gitea
            '';
        };

        virtualisation.oci-containers.containers.gitea = {
            autoStart = true;
            image = "gitea/gitea:1.21.0";
            volumes = cfg.gitea_volumes;
            ports = [
                "3000:3000"
                "2221:22"
            ];
            environmentFiles = [ cfg.env_file ];
            environment = {
                USER_UID = "1000";
                USER_GID = "1000";
                GITEA__database__DB_TYPE= "postgres";
                GITEA__database__HOST= "gitea_db:5432";
            };
            dependsOn = [ "gitea_db" ];
            extraOptions = ["--network=gitea"];
        };

        virtualisation.oci-containers.containers.gitea_db = {
            autoStart = true;
            image = "postgres:14";
            volumes = cfg.pg_volumes;
            environmentFiles = [ cfg.env_file ];
            extraOptions = ["--network=gitea"];
        };

        virtualisation.oci-containers.containers.gitea_runner = {
            autoStart = true;
            image = "gitea/act_runner:latest";
            volumes = cfg.runner_volumes;
            environmentFiles = [ cfg.env_file ];
            environment = {
                CONFIG_FILE = "/config.yaml";
                GITEA_INSTANCE_URL = "https://git.iatze.cc";
                GITEA_RUNNER_NAME = "runner_1";
            };
            extraOptions = ["--network=gitea"];
        };

    };
}
