{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.casa.services.media;
in
{
  options.casa.services.media = {
    enable = mkEnableOption "media";
    storage = mkOption {
      type = types.str;
      default = config.casa.profiles.server.storage;
    };
  };

  config = mkIf cfg.enable {
    casa.services = {
      jellyfin.enable = true;
      kavita.enable = true;
      radarr.enable = true;
      seerr.enable = true;
      sonarr.enable = true;
    };

    users.groups.media = { };

    # TODO: use genAttrs
    systemd.tmpfiles.settings."media-dirs" =
      let
        user = "-";
        group = "media";
        mode = "0775";
      in
      {
        "${cfg.storage}/media".d = { inherit user group mode; };
        "${cfg.storage}/media/anime".d = { inherit user group mode; };
        "${cfg.storage}/media/anime_movies".d = { inherit user group mode; };
        "${cfg.storage}/library".d = { inherit user group mode; };
        "${cfg.storage}/library/lightnovels".d = { inherit user group mode; };
        "${cfg.storage}/library/manga".d = { inherit user group mode; };
      };
  };
}
