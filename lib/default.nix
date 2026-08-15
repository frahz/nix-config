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

  # Adapted from Home Manager's Hyprland renderer, via Hjem Rum.
  # https://github.com/snugnug/hjem-rum/blob/5b60842e8f76ae5e818b502f874c469a92930d42/modules/lib/generators/hypr.nix
  toHyprconf =
    {
      attrs,
      indentLevel ? 0,
      importantPrefixes ? lib.lists.singleton "$",
    }:
    let
      inherit (builtins)
        all
        isAttrs
        isList
        removeAttrs
        ;
      inherit (lib.attrsets) filterAttrs mapAttrsToList;
      inherit (lib.generators) toKeyValue;
      inherit (lib.lists) foldl replicate;
      inherit (lib.strings)
        concatMapStringsSep
        concatStrings
        concatStringsSep
        hasPrefix
        ;

      initialIndent = concatStrings (replicate indentLevel "  ");

      render =
        indent: values:
        let
          sections = filterAttrs (_: value: isAttrs value || (isList value && all isAttrs value)) values;

          renderSection =
            name: section:
            if isList section then
              concatMapStringsSep "\n" (value: renderSection name value) section
            else
              ''
                ${indent}${name} {
                ${render "  ${indent}" section}${indent}}
              '';

          renderFields = toKeyValue {
            listsAsDuplicateKeys = true;
            inherit indent;
          };

          allFields = filterAttrs (_: value: !(isAttrs value || (isList value && all isAttrs value))) values;
          isImportant =
            name: _: foldl (found: prefix: found || hasPrefix prefix name) false importantPrefixes;
          importantFields = filterAttrs isImportant allFields;
          fields = removeAttrs allFields (mapAttrsToList (name: _: name) importantFields);
        in
        renderFields importantFields
        + concatStringsSep "\n" (mapAttrsToList renderSection sections)
        + renderFields fields;
    in
    render initialIndent attrs;

  casaLib = lib.fixedPoints.makeExtensible (final: {
    inherit mkServiceOption mkSecret toHyprconf;
  });
in
{
  flake.lib = casaLib;
}
