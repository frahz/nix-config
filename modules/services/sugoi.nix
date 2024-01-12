{ config, pkgs, lib, ... }:

with lib;
let
    cfg = config.services.sugoi;
in
{
    options.services.sugoi = {
        enable = mkEnableOption "sugoi daemon";
    };

    config = mkIf cfg.enable {
        networking.firewall = {
            allowedTCPPorts = [ 8080 ];
            allowedUDPPorts = [ 8080 ];
        };

        systemd.packages = [ pkgs.sugoi ];

        systemd.services.sugoi = {
            enable = true;
            description = "Sugoi wakeup service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = ''${pkgs.sugoi}/bin/sugoi'';
            };
        };
    };
}
