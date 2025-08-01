{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;

  cfg = config.casa.services.nemui;
in
{
  options.casa.services.nemui = {
    enable = mkEnableOption "nemui daemon";
    port = mkOption {
      type = lib.types.port;
      default = 8253;
      description = "The port for freshrss service";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
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
