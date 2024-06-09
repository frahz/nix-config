{inputs, ...}: let
  overlay-local = import ../pkgs;
in {
  nixpkgs = {
    overlays = [
      overlay-local
      inputs.hypridle.overlays.default
      inputs.hyprlock.overlays.default
      inputs.hyprpaper.overlays.default
      inputs.hyprpicker.overlays.default
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
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "frahz-pkgs.cachix.org-1:76ecCnIcJvDeJzHqFyAI6ElUndNZK0RXAO3HQrmV468="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
