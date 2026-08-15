{
  config,
  inputs',
  lib,
  pkgs,
  ...
}:
let
  cfg = config.casa.profiles.graphical;
  extensions = [
    "aghfnjkcakhmadgdomlmlhhaocbkloab" # Theme
    "cdglnehniifkbagbbombnjghhcihifij" # Kagi Search
    "clngdbkpkpeebahjckkjfobafhncgmne" # stylus
    "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "pnidmkljnhbjfffciajlcpeldoljnidn" # Linkwarden
  ];
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = lib.lists.singleton inputs'.paquetes.packages.helium;

      xdg.config.files = lib.listToAttrs (
        map (id: {
          name = "chromium/External Extensions/${id}.json";
          value = {
            generator = (pkgs.formats.json { }).generate "chromium-extension-${id}.json";
            value.external_update_url = "https://clients2.google.com/service/update2/crx";
          };
        }) extensions
      );
    };
  };
}
