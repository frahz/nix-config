{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.container.freshrss;
in {
  options.container.freshrss = {
    volumes = mkOption {
      type = with types; listOf str;
    };
  };

  config = {
    networking.firewall = {
      allowedTCPPorts = [9123];
      allowedUDPPorts = [9123];
    };

    virtualisation.oci-containers.containers.freshrss = {
      autoStart = true;
      image = "lscr.io/linuxserver/freshrss:latest";
      inherit (cfg) volumes;
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Los_Angeles";
      };
      ports = [
        "9123:80"
      ];
    };
  };
}
