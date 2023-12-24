{config, lib, ...}:
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
            allowedTCPPorts = [ 3020 ];
            allowedUDPPorts = [ 3020 ];
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
                "3020:3000"
            ];
            dependsOn = [ "linkwarden_pg" ];
        };

        virtualisation.oci-containers.containers.linkwarden_pg = {
            autoStart = true;
            image = "postgres:16-alpine";
            volumes = cfg.pg_volumes;
            environment = {
                TZ = "America/Los_Angeles";
            };
            environmentFiles = cfg.env_files;
        };
    };
}
