{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.container.jellyfin;
in {
  options.container.jellyfin = {
    volumes = mkOption {
      type = with types; listOf str;
    };
  };

  config = {
    networking.firewall = {
      allowedTCPPorts = [8096];
      allowedUDPPorts = [8096];
    };

    virtualisation.oci-containers.containers.jellyfin = {
      autoStart = true;
      image = "jellyfin/jellyfin";
      inherit (cfg) volumes;
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "America/Los_Angeles";
      };
      ports = [
        "8096:8096"
      ];
      extraOptions = [
        "--device=/dev/dri/renderD128:/dev/dri/renderD128"
        "--device=/dev/dri/card0:/dev/dri/card0"
      ];
    };
  };
}
