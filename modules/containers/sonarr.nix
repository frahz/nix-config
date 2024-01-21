{ config, lib, ... }:

with lib;
let
    cfg = config.container.sonarr;
in
{
    options.container.sonarr = {
        volumes = mkOption {
            type = with types; listOf str;
        };
    };

    config = {
        networking.firewall = {
            allowedTCPPorts = [ 8990 ];
            allowedUDPPorts = [ 8990 ];
        };

        virtualisation.oci-containers.containers.sonarr = {
            autoStart = true;
            image = "lscr.io/linuxserver/sonarr:4.0.1.929-ls222";
            volumes = cfg.volumes;
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
            };
            ports = [
                "8990:8989"
            ];
        };
    };
}

