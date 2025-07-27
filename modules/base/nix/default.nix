{ pkgs, ... }:
{
  imports = [ ./nh.nix ];

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
        allowed-users = [ "@wheel" ];
        trusted-users = [
          "root"
          "@wheel"
        ];
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
