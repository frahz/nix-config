{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.sugoi;
in {
  options.services.sugoi = {
    enable = mkEnableOption "sugoi daemon";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = ''The Port which sugoi service will listen on.'';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [cfg.port];
      allowedUDPPorts = [cfg.port];
    };

    systemd.services.sugoi = {
      enable = true;
      description = "sugoi Wakeup Service";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        PORT = toString cfg.port;
        SUGOI_DB_PATH = "/var/lib/sugoi/sugoi.db";
      };
      serviceConfig = {
        Type = "simple";
        StateDirectory = "sugoi";
        ExecStart = ''${inputs.sugoi.packages.${pkgs.system}.default}/bin/sugoi'';
      };
    };
  };
}
