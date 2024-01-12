{
    description = "le nix config";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

        flake-utils.url = "github:numtide/flake-utils";

        home.url = "github:nix-community/home-manager";
        home.inputs.nixpkgs.follows = "nixpkgs";

        sops-nix.url = "github:Mic92/sops-nix";
        sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-unstable,
        flake-utils,
        home,
        sops-nix,
        ...
    } @ inputs:
    let
        inherit (self) outputs;
        /* systems = flake-utils.lib.system; */
        defaultModules = [
            sops-nix.nixosModules.default
            /* home.nixOsModules.default */
        ];
    in
    {
        nixosConfigurations = (
            import ./hosts {
                inherit (nixpkgs) lib;
                inherit inputs nixpkgs nixpkgs-unstable home defaultModules;
            }
        );
    };
}
