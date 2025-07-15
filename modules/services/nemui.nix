{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.nemui;
in
{
  options.services.nemui = {
    enable = mkEnableOption "nemui daemon";
  };

  config = mkIf cfg.enable {
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
