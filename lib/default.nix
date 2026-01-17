{ inputs, lib, ... }:
let
  inherit (lib.types) str;
  inherit (lib.options) mkOption mkEnableOption;

  /**
    A quick way to use my services abstraction

    # Arguments

    - [name]: The name of the service

    # Type

    ```
    mkServiceOption :: String -> (Int -> String -> String -> AttrSet) -> AttrSet
    ```
  */
  mkServiceOption =
    name:
    {
      port ? 0,
      host ? "127.0.0.1",
      domain ? "",
      storagePath ? "/var/lib",
    }:
    {
      enable = mkEnableOption "Enable the ${name} service";

      host = mkOption {
        type = str;
        default = host;
        description = "The host for ${name} service";
      };

      port = mkOption {
        type = lib.types.port;
        default = port;
        description = "The port for ${name} service";
      };

      domain = mkOption {
        type = str;
        default = domain;
        defaultText = "networking.domain";
        description = "Domain name for the ${name} service";
      };

      storagePath = mkOption {
        type = str;
        default = storagePath;
        description = "The storage location for ${name}";
      };
    };

  casaLib = lib.fixedPoints.makeExtensible (final: {
    inherit mkServiceOption;
  });
in
{
  flake.lib = casaLib;
}
