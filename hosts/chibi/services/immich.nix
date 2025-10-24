{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.immich;

  mediaDir = "/mnt/kuki/photos";

  postgresqlPackage =
    if cfg.database.enable then config.services.postgresql.package else pkgs.postgresql;
in
{
  sops.secrets.immich = { };
  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    secretsFile = config.sops.secrets.immich.path;
    redis = {
      enable = true;
    };
    accelerationDevices = [
      "/dev/dri/renderD128"
    ];
  };

  # https://github.com/NixOS/nixpkgs/pull/454606
  systemd.services.postgresql-setup.serviceConfig.ExecStartPost =
    let
      extensions = [
        "unaccent"
        "uuid-ossp"
        "cube"
        "earthdistance"
        "pg_trgm"
      ]
      ++ lib.optionals cfg.database.enableVectors [
        "vectors"
      ]
      ++ lib.optionals cfg.database.enableVectorChord [
        "vector"
        "vchord"
      ];
      sqlFile = pkgs.writeText "immich-pgvectors-setup.sql" (
        ''
          ${lib.concatMapStringsSep "\n" (ext: "CREATE EXTENSION IF NOT EXISTS \"${ext}\";") extensions}
          ${lib.concatMapStringsSep "\n" (ext: "ALTER EXTENSION \"${ext}\" UPDATE;") extensions}
          ALTER SCHEMA public OWNER TO ${cfg.database.user};
        ''
        + lib.optionalString cfg.database.enableVectors ''
          ALTER SCHEMA vectors OWNER TO ${cfg.database.user};
          GRANT SELECT ON TABLE pg_vector_index_stat TO ${cfg.database.user};
        ''
        # https://docs.immich.app/administration/postgres-standalone/#updating-vectorchord
        + lib.optionalString cfg.database.enableVectorChord ''
          REINDEX INDEX face_index;
          REINDEX INDEX clip_index;
        ''
      );
    in
    [
      ''
        ${lib.getExe' postgresqlPackage "psql"} -d "${cfg.database.name}" -f "${sqlFile}"
      ''
    ];

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  services.caddy.virtualHosts."photos.iatze.cc" =
    let
      cfg = config.services.immich;
    in
    {
      extraConfig = ''
        reverse_proxy http://${cfg.host}:${toString cfg.port}
      '';
    };

  systemd.tmpfiles.rules = [
    "d ${mediaDir} 0775 immich immich - -"
  ];

  # Workaround
  fileSystems."/var/lib/immich" = {
    device = mediaDir;
    options = [ "bind" ];
  };
}
