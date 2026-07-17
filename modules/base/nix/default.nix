{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) filterAttrs attrValues mapAttrs;
  inherit (lib.types) isType;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  sudoers = if isLinux then "@wheel" else "@admin";
  flakeInputs = filterAttrs (name: value: (isType "flake" value) && (name != "self")) inputs;
in
{
  config = {
    nix = {
      package = pkgs.lixPackageSets.latest.lix;

      # disable usage of nix channels
      channel.enable = false;

      # Pin registry and NIX_PATH to inputs nixpkgs
      # https://github.com/getchoo/borealis/blob/52da5ea4eaaddb5f8b1dc32c1dcefbfda68a52fc/modules/shared/mixins/nix.nix#L44
      # https://github.com/isabelroses/dotfiles/blob/acdb74a1fedd1b1dfce303e8ee285a7a884ac7fe/modules/base/nix/registry.nix
      registry = mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = attrValues (mapAttrs (k: v: "${k}=flake:${v.outPath}") flakeInputs);

      settings = {
        warn-dirty = false;
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        builders-use-substitutes = true;

        log-lines = 35;

        keep-going = true;
        keep-derivations = true;
        keep-outputs = true;

        # use xdg base directories for all the nix things
        use-xdg-base-directories = true;

        allowed-users = [ sudoers ];
        trusted-users = [ sudoers ];
        substituters = [
          "https://frahz-pkgs.cachix.org"
        ];
        trusted-public-keys = [
          "frahz-pkgs.cachix.org-1:76ecCnIcJvDeJzHqFyAI6ElUndNZK0RXAO3HQrmV468="
        ];
      };
    };
  };
}
