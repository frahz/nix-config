{ inputs, lib, ... }:
let
  inherit (inputs) self;
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

  /**
    Create secrets for use with `sops`.

    # Arguments

    - [file] the age file to use for the secret
    - [owner] the owner of the secret, this defaults to "root"
    - [group] the group of the secret, this defaults to "root"
    - [mode] the permissions of the secret, this defaults to "400"

    # Type

    ```
    mkSecret :: (String -> String -> String -> String) -> AttrSet
    ```

    # Example

    ```nix
    mkSecret { file = "my-secret"; }
    => {
      file = "my-secret";
      owner = "root";
      group = "root";
      mode = "400";
    }
    ```
  */
  mkSecret =
    {
      file,
      owner ? "root",
      group ? "root",
      mode ? "0400",
      ...
    }@args:
    let
      args' = removeAttrs args [
        "file"
        "owner"
        "group"
        "mode"
      ];
    in
    {
      sopsFile = "${self}/secrets/services/${file}.yaml";
      inherit owner group mode;
    }
    // args';

  casaLib = lib.fixedPoints.makeExtensible (final: {
    inherit mkServiceOption mkSecret;
  });
in
{
  flake.lib = casaLib;
}
