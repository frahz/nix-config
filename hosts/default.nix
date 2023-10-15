{ lib, inputs, nixpkgs, nixpkgs-unstable, ...}:

let
    system = "x86_64-linux";

    lib = nixpkgs.lib;
in
{
    chibi = lib.nixosSystem {
        inherit system;
        specialArgs = {
            inherit inputs system;
            host = {
                hostName = "chibi";
            };
        };
        modules = [
            ./chibi
            ./configuration.nix
        ];
    };
}
