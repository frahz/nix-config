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
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [8080];
      allowedUDPPorts = [8080];
    };

    systemd.services.sugoi = {
      enable = true;
      description = "sugoi Wakeup Service";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${inputs.sugoi.packages.${pkgs.system}.default}/bin/sugoi'';
      };
    };
  };
}
