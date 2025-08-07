{
  description = "le nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Do not follow nixpkgs as it takes forever to build each time
    # Does not matter anyway, it's just fonts
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    # fixes: https://github.com/the-argus/spicetify-nix/issues/48
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private-flake = {
      url = "git+ssh://git@github.com/frahz/private-flake.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    paquetes.url = "github:frahz/paquetes";

    sugoi.url = "github:frahz/sugoi";
    nvim-flake.url = "github:frahz/nvim-flake";
    tailray = {
      url = "github:frahz/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks.flakeModule
        ./hosts
      ];

      systems = [ "x86_64-linux" ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          pre-commit = {
            check.enable = true;
            settings = {
              hooks = {
                nixfmt-rfc-style.enable = true;
                statix.enable = true;
              };
            };
          };

          devShells.default = pkgs.mkShell {
            shellHook = config.pre-commit.installationScript;
            packages = with pkgs; [
              config.formatter
              git
              sops
              statix
            ];
          };

          formatter = pkgs.nixfmt-tree;
        };
    };
}
