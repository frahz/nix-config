{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  sudoers = if isLinux then "@wheel" else "@admin";
in
{
  config = {
    nix = {
      package = pkgs.lixPackageSets.latest.lix;
      settings = {
        warn-dirty = false;
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        builders-use-substitutes = true;
        keep-derivations = true;
        keep-outputs = true;
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
