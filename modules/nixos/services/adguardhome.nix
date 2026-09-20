{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.adguardhome;
  lanInterface = config.casa.networking.interfaces."10-lan" or "";
  rdomain = config.networking.domain;
in
{
  options.casa.services.adguardhome =
    mkServiceOption "adguardhome" {
      port = 8053;
      domain = "adguard.${rdomain}";
    }
    // {
      dnsPort = mkOption {
        type = lib.types.port;
        default = 53;
        description = "The torrenting port for qbittorrent service";
      };

    };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = lanInterface != "";
        message = "Home Assistant requires casa.networking.interfaces.\"10-lan\" to identify its LAN interface.";
      }
    ];

    networking.firewall.interfaces = lib.genAttrs [ lanInterface "tailscale0" ] (_: {
      allowedTCPPorts = [ cfg.dnsPort ];
      allowedUDPPorts = [ cfg.dnsPort ];
    });

    services = {
      adguardhome = {
        enable = true;
        inherit (cfg) port;
        settings = {
          theme = "dark";
          auth_attempts = 5;
          block_auth_min = 15;
          dns = {
            port = cfg.dnsPort;
            bind_hosts = [ "0.0.0.0" ];
            bootstrap_dns = [
              "1.1.1.1"
              "8.8.8.8"
            ];
            upstream_dns = [
              "1.1.1.1"
              "8.8.8.8"
            ];

            private_networks = [
              "100.64.0.0/10"
              "fd7a:115c:a1e0::/48"

              "192.168.0.0/16"
              "10.0.0.0/8"
              "172.16.0.0/12"
            ];

            use_private_ptr_resolvers = true;
            local_ptr_upstreams = [
              "100.100.100.100"
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

      resolved.settings.Resolve = {
        DNS = [ "127.0.0.1" ];
        DNSStubListener = "no";
      };

      caddy.virtualHosts.${cfg.domain} = {
        extraConfig = ''
          reverse_proxy http://${cfg.host}:${toString cfg.port}
        '';
      };
    };
  };
}
