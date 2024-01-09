{ config, pkgs, lib, ... }:

let
    cfg = config.services.nemui;
in
{
    options = {
        services.nemui = {
            enable = lib.mkEnableOption "nemui daemon";
        };
    };

    config = lib.mkIf cfg.enable {
        networking.firewall = {
            allowedTCPPorts = [ 8253 ];
            allowedUDPPorts = [ 8253 ];
        };

        systemd.packages = [ pkgs.nemui ];

        systemd.services.nemui = {
            enable = true;
            description = "Nemui sleep service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = ''${pkgs.nemui}/bin/nemui'';
            };
        };
    };
}
