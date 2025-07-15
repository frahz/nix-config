{ config, ... }:
let
  cfg = config.media;
in
{
  sops.secrets.kavita = { };

  services.kavita = {
    enable = true;
    dataDir = "${cfg.storage}/containers/kavita";
    tokenKeyFile = config.sops.secrets.kavita.path;
  };
  users.users.kavita.extraGroups = [ "media" ];
}
