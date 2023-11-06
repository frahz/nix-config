{ lib, inputs, nixpkgs, nixpkgs-unstable, ...}:

let
    system = "x86_64-linux";


    unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
    };

    lib = nixpkgs.lib;
in
{
    chibi = lib.nixosSystem {
        inherit system;
        specialArgs = {
            inherit inputs system unstable;
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
