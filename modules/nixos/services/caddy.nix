{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.casa.services.caddy;
in
{
  options.casa.services.caddy = mkServiceOption "caddy" { };

  config = mkIf cfg.enable {
    sops.secrets.porkbun = { };

    services.caddy = {
      enable = true;
      email = "me@frahz.dev";
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
        hash = "sha256-C+eTduZvOlewyzOxtTqmmWXL2yVqAq/ltq+XrzD1otY=";
      };
      globalConfig = ''
        acme_dns porkbun {
          api_key {env.PORKBUN_API_KEY}
          api_secret_key {env.PORKBUN_API_SECRET_KEY}
        }
      '';
      environmentFile = config.sops.secrets.porkbun.path;
    };

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
        80
        443
      ];
    };
  };
}
