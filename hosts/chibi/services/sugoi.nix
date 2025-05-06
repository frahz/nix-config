{config, ...}: {
  services.sugoi.enable = true;

  services.caddy.virtualHosts."sugoi.${config.homelab.domain}" = {
    extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.sugoi.port}
    '';
  };
}
