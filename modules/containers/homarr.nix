{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.container.homarr;
in {
  options.container.homarr = {
    volumes = mkOption {
      type = with types; listOf str;
    };
  };

  config = {
    networking.firewall = {
      allowedTCPPorts = [7575];
      allowedUDPPorts = [7575];
    };

    # TODO: fully remove once I add support for jellyseerr and sonarr calendar events to glance
    virtualisation.oci-containers.containers.homarr = {
      autoStart = true;
      image = "ghcr.io/ajnart/homarr:0.15.3";
      inherit (cfg) volumes;
      environment = {
        TZ = "America/Los_Angeles";
      };
      ports = [
        "7575:7575"
      ];
    };
  };
}
