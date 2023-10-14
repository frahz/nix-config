{
    description = "le nix config";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

        flake-utils.url = "github:numtide/flake-utils";

        home.url = "github:nix-community/home-manager";
        home.inputs.nixpkgs.follows = "nixpkgs";

        agenix.url = "github:ryantm/agenix";
        agenix.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-unstable,
        flake-utils,
        home,
        agenix,
        ...
    } @ inputs:
    let
        inherit (self) outputs;
        systems = flake-utils.lib.system;
        defaultModules = [
            agenix.nixOsModules.default
            home.nixOsModules.default
        ];
    in
    {
        nixosConfigurations = {
            hostname = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./configuration.nix
            ];
            };
        };
    };
}
