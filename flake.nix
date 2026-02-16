{
  description = "le nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    flake-parts.url = "github:hercules-ci/flake-parts";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    privado = {
      url = "git+ssh://git@github.com/frahz/privado.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    paquetes = {
      url = "github:frahz/paquetes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-flake = {
      url = "github:frahz/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./lib
        ./hosts
      ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              config.formatter
              git
              just
              nix-output-monitor
              sops
              statix
            ];
          };

          formatter = pkgs.nixfmt-tree;
        };
    };
}
