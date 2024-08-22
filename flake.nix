{
  description = "le nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    anyrun.url = "github:Kirottu/anyrun";

    # For now, until that hyprland recompilation thing is fixed
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Do not follow nixpkgs as it takes forever to build each time
    # Does not matter anyway, it's just fonts
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    # fixes: https://github.com/the-argus/spicetify-nix/issues/48
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nil.url = "github:oxalica/nil";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    raulyrs.url = "github:frahz/rauly.rs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.pre-commit-hooks.flakeModule
        ./home/profiles
        ./hosts
      ];

      systems = ["x86_64-linux"];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        pre-commit = {
          check.enable = true;
          settings = {
            hooks = {
              alejandra.enable = true;
              statix.enable = true;
            };
          };
        };

        devShells.default = pkgs.mkShell {
          shellHook = config.pre-commit.installationScript;
          packages = with pkgs; [
            git
            sops
            alejandra
            statix
          ];
        };

        formatter = pkgs.alejandra;
      };
    };
}
