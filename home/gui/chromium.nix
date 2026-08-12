{
  inputs',
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  cfg = osConfig.casa;
in
{
  config = mkIf (cfg.profiles.graphical.enable && isLinux) {
    home.packages = [
      inputs'.paquetes.packages.helium
    ];

    programs.chromium = {
      enable = true;
      extensions = [
        # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
        "clngdbkpkpeebahjckkjfobafhncgmne" # stylus
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "pnidmkljnhbjfffciajlcpeldoljnidn" # Linkwarden
        "cdglnehniifkbagbbombnjghhcihifij" # Kagi Search
        "aghfnjkcakhmadgdomlmlhhaocbkloab" # Theme
      ];
      package = null;
    };
  };
}
