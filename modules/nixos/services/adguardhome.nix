{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.adguardhome;
  rdomain = config.networking.domain;
  dns_port = 53;
in
{
  options.casa.services.adguardhome = mkServiceOption "adguardhome" {
    port = 8053;
    domain = "adguard.${rdomain}";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        dns_port
        cfg.port
      ];
      allowedUDPPorts = [ dns_port ];
    };
    services.adguardhome = {
      enable = true;
      openFirewall = true;
      port = cfg.port;
      settings = {
        theme = "dark";
        users = [
          {
            name = "frahz";
            password = "$2a$04$QfS54PuYCPt1veli1xX75erTSovYT9x7g.NFsnq9O3r53WTXqHoBy";
          }
        ];
        dns = {
          port = dns_port;
          bind_hosts = [ "0.0.0.0" ];
          bootstrap_dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          upstream_dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          ratelimit = 100;
        };
        filters = [
          {
            name = "AdGuard DNS filter";
            url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
            enabled = true;
            id = 1;
          }
          {
            name = "AdAway Default Blocklist";
            url = "https://adaway.org/hosts.txt";
            enabled = true;
            id = 2;
          }
          {
            name = "OISD Blocklist Big";
            url = "https://big.oisd.nl";
            enabled = true;
            id = 3;
          }
        ];
      };
    };

    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
