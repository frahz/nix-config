{ config, lib, ... }:

with lib;
let
    cfg = config.container.torrent;
in
{
    options.container.torrent = {
        /* enable = mkEnableOption "qbittorent container"; */
        qb_volumes = mkOption {
            type = with types; listOf str;
        };
        gluetun_volumes = mkOption {
            type = with types; listOf str;
        };
        vpn_info_file = mkOption {
            type = with types; str;
        };
    };

    config = {
        networking.firewall = {
            allowedTCPPorts = [ 8888 8080 26570 ];
            allowedUDPPorts = [ 8080 26570 ];
        };

        virtualisation.oci-containers.containers.gluetun = {
            autoStart = true;
            image = "qmcgaw/gluetun:v3.37.0";
            volumes = cfg.gluetun_volumes;
            ports = [
                "8888:8888/tcp"
                "8080:8080"
                "26570:26570"
            ];
            environmentFiles = [ cfg.vpn_info_file ];
            environment = {
                TZ = "America/Los_Angeles";
                VPN_SERVICE_PROVIDER = "airvpn";
                VPN_TYPE = "wireguard";
            };
            extraOptions = ["--cap-add=NET_ADMIN"];
        };

        virtualisation.oci-containers.containers.qbittorrent = {
            autoStart = true;
            image = "lscr.io/linuxserver/qbittorrent:4.6.2-r0-ls303";
            volumes = cfg.qb_volumes;
            environment = {
                TZ = "America/Los_Angeles";
                PUID = "1000";
                PGID = "1000";
                WEB_UI_PORT = "8080";
            };
            dependsOn = [ "gluetun" ];
            extraOptions = [ "--network=container:gluetun" ];
        };

    };
}
