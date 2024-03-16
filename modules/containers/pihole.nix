{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.container.pihole;
in {
  options.container.pihole = {
    volumes = mkOption {
      type = with types; listOf str;
    };
  };

  config = {
    networking.firewall = {
      allowedTCPPorts = [53 8035];
      allowedUDPPorts = [53];
    };

    virtualisation.oci-containers.containers.pihole = {
      autoStart = true;
      image = "pihole/pihole:2024.02.2";
      inherit (cfg) volumes;
      environment = {
        TZ = "America/Los_Angeles";
        DNSMASQ_LISTENING = "all";
      };
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "8053:80/tcp"
      ];
      extraOptions = ["--cap-add=NET_ADMIN"];
    };
  };
}
