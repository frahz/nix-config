{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mkIf
    mkOption
    mkDefault
    mkEnableOption
    literalExpression
    ;
  inherit (lib.types) attrs;

  commonSettings = {
    "browseable" = "yes";
    "read only" = "no";
    "inherit permissions" = "yes";
  };

  cfg = config.casa.services.samba;
in
{
  options.casa.services.samba = {
    enable = mkEnableOption "samba shares";
    shares = mkOption {
      type = attrs;
      example = literalExpression ''
        Backups = {
          path = "/mnt/Backups";
        };
      '';
      default = { };
    };
  };

  config = mkIf cfg.enable {
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    services.samba = {
      enable = true;
      settings = {
        global = {
          workgroup = mkDefault "WORKGROUP";
          "server string" = mkDefault config.networking.hostName;
          "server role" = mkDefault "standalone server";
          "pam password change" = mkDefault "yes";
          "map to guest" = mkDefault "bad user";
          "usershare allow guests" = mkDefault "yes";
        };
      }
      // mapAttrs (name: value: value // commonSettings) cfg.shares;
    };

  };
}
