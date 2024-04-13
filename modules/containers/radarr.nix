{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.container.radarr;
in {
  options.container.radarr = {
    volumes = mkOption {
      type = with types; listOf str;
    };
  };

  config = {
    networking.firewall = {
      allowedTCPPorts = [7878];
      allowedUDPPorts = [7878];
    };

    virtualisation.oci-containers.containers.radarr = {
      autoStart = true;
      image = "lscr.io/linuxserver/radarr:5.4.6.8723-ls213";
      inherit (cfg) volumes;
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Los_Angeles";
      };
      ports = [
        "7878:7878"
      ];
    };
  };
}
