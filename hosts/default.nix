{ lib, inputs, nixpkgs, nixpkgs-unstable, defaultModules, ...}:

let
    system = "x86_64-linux";

    overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
        };
    };

    lib = nixpkgs.lib;
in
{
    chibi = lib.nixosSystem {
        inherit system;
        specialArgs = {
            inherit inputs system overlay-unstable;
            host = {
                hostName = "chibi";
            };
        };
        modules = [
            ./chibi
            ./configuration.nix
        ] ++ defaultModules;
    };
}
