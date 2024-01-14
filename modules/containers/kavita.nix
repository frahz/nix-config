{ config, lib, ... }:

with lib;
let
    cfg = config.container.kavita;
in
{
    options.container.kavita = {
        volumes = mkOption {
            type = with types; listOf str;
        };
    };

    config = {
        networking.firewall = {
            allowedTCPPorts = [ 5000 ];
            allowedUDPPorts = [ 5000 ];
        };

        virtualisation.oci-containers.containers.kavita = {
            autoStart = true;
            image = "kizaing/kavita:latest";
            volumes = cfg.volumes;
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
            };
            ports = [
                "5000:5000"
            ];
        };
    };

}

