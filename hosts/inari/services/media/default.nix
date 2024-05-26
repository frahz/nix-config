{
  config,
  lib,
  ...
}: let
  cfg = config.media;
in {
  imports = [./kavita.nix ./radarr.nix ./sonarr.nix];

  options.media = with lib; {
    storage = mkOption {
      type = types.str;
      default = "/mnt/mizu";
    };
  };
  config = {
    users.groups.media = {};
    users.users.frahz.extraGroups = ["media"];

    systemd.tmpfiles.rules = [
      "d ${cfg.storage}/media 0770 - media - -"
      "d ${cfg.storage}/library 0770 - media - -"
    ];
  };
}
