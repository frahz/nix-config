{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.container.jellyseerr;
in {
  options.container.jellyseerr = {
    volumes = mkOption {
      type = with types; listOf str;
    };
  };

  config = {
    networking.firewall = {
      allowedTCPPorts = [5055];
      allowedUDPPorts = [5055];
    };

    virtualisation.oci-containers.containers.jellyseerr = {
      autoStart = true;
      image = "fallenbagel/jellyseerr:latest";
      volumes = cfg.volumes;
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Los_Angeles";
      };
      ports = [
        "5055:5055"
      ];
    };
  };
}
