{config, lib, pkgs, ...}:
with lib;
let
    cfg = config.container.linkwarden;
in {
    options.container.linkwarden = {
        volumes = mkOption {
            type = with types; listOf str;
        };
        pg_volumes = mkOption {
            type = with types; listOf str;
        };
        env_files = mkOption {
            type = with types; listOf path;
        };
    };

    config = {
        networking.firewall = {
            allowedTCPPorts = [ 3000 ];
            allowedUDPPorts = [ 3000 ];
        };

        systemd.services.init-linkwarden-network = {
            description = "Create bridge for linkwarden";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            serviceConfig.Type = "oneshot";
            script = let
                docker = config.virtualisation.oci-containers.backend;
                dockerBin = "${pkgs.${docker}}/bin/${docker}";
            in ''
                ${dockerBin} network inspect linkwarden-br >/dev/null 2>&1 || ${dockerBin} network create linkwarden-br
            '';
        };

        virtualisation.oci-containers.containers.linkwarden = {
            autoStart = true;
            image = "ghcr.io/linkwarden/linkwarden:v2.3.0";
            volumes = cfg.volumes;
            environment = {
                TZ = "America/Los_Angeles";
            };
            environmentFiles = cfg.env_files;
            ports = [
                "3000:3000"
            ];
            dependsOn = [ "linkwarden_pg" ];
            extraOptions = [ "--network=linkwarden-br" ];
        };

        virtualisation.oci-containers.containers.linkwarden_pg = {
            autoStart = true;
            image = "postgres:16-alpine";
            volumes = cfg.pg_volumes;
            environment = {
                TZ = "America/Los_Angeles";
            };
            environmentFiles = cfg.env_files;
            extraOptions = [ "--network=linkwarden-br" ];
        };
    };
}
