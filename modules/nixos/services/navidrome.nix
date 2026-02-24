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

  cfg = config.casa.services.navidrome;
  rdomain = config.networking.domain;
in
{
  options.casa.services.navidrome = mkServiceOption "navidrome" {
    host = "0.0.0.0";
    port = 4533;
    domain = "music.${rdomain}";
  };

  config = mkIf cfg.enable {
    sops.secrets.navidrome = { };
    services.navidrome = {
      enable = true;
      # TODO: fix https://github.com/NixOS/nixpkgs/issues/481611
      package = pkgs.navidrome.overrideDerivation (old: {
        CGO_CFLAGS_ALLOW = "--define-prefix";
      });
      settings = {
        Address = cfg.host;
        Port = cfg.port;
        MusicFolder = "${cfg.storagePath}/music";
        EnableInsightsCollector = false;
      };
      environmentFile = config.sops.secrets.navidrome.path;
      openFirewall = true;
    };
    services.caddy.virtualHosts.${cfg.domain} = {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };
  };
}
