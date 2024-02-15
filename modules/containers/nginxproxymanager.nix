{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.container.nginxproxymanager;
in {
  options.container.nginxproxymanager = {
    volumes = mkOption {
      type = with types; listOf str;
    };
  };

  config = {
    networking.firewall = {
      allowedTCPPorts = [80 81 443];
      allowedUDPPorts = [80 81 443];
    };

    virtualisation.oci-containers.containers.nginxproxymanager = {
      autoStart = true;
      image = "jc21/nginx-proxy-manager:2.10.4";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/Los_Angeles";
      };
      ports = [
        "80:80" # Public HTTP Port
        "81:81" # Admin Port
        "443:443" # Public HTTPS Port
      ];
    };
  };
}
