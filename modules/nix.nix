{
  inputs,
  overlay-local,
  overlay-unstable,
  ...
}: {
  nixpkgs = {
    overlays = [
      overlay-local
      overlay-unstable
      inputs.raulyrs.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    builders-use-substitutes = true;
    keep-outputs = true;
    trusted-users = ["root" "@wheel"];
    substituters = [
      "https://frahz-pkgs.cachix.org"
    ];
    trusted-public-keys = [
      "frahz-pkgs.cachix.org-1:76ecCnIcJvDeJzHqFyAI6ElUndNZK0RXAO3HQrmV468="
    ];
  };
}
