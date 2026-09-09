{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.casa.profiles.development;
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz.packages = builtins.attrValues {
      inherit (pkgs) codex pi-coding-agent;
    };
  };
}
