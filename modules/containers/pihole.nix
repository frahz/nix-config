{config, ...}:

{
    networking.firewall = {
        allowedTCPPorts = [ 53 8035 ];
        allowedUDPPorts = [ 53 ];
    };

    virtualisation.oci-containers.containers.pihole = {
        autoStart = true;
        image = "pihole/pihole:2023.10.0";
        volumes = [ "/var/lib/pihole:/etc/pihole/" ];
        environment = {
            TZ = "America/Los_Angeles";
        };
        ports = [
            "53:53/tcp"
            "53:53/udp"
            "8053:80/tcp"
        ];
        extraOptions = [
            "--cap-add=NET_ADMIN"
            "--network=host"
        ];
    };
}
