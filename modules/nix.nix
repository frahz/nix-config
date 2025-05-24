{pkgs, ...}: let
  overlay-local = import ../pkgs;
in {
  nixpkgs = {
    overlays = [
      overlay-local
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      substituters = [
        "https://frahz-pkgs.cachix.org"
      ];
      trusted-public-keys = [
        "frahz-pkgs.cachix.org-1:76ecCnIcJvDeJzHqFyAI6ElUndNZK0RXAO3HQrmV468="
      ];
    };
  };

  # TODO: until https://github.com/NixOS/nixpkgs/issues/360592 is resolved
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-runtime-6.0.36"
    "dotnet-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];
}
