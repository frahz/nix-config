{
  lib,
  self,
  inputs,
  ...
}:
let
  inherit (lib) mkDefault;

  homeImports = import "${self}/home/profiles";

  mkNixosSystem =
    name:
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
      homeProfile ? homeImports.default,
      specialArgs ? { inherit inputs self system; },
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = [
        "${self}/modules/nixos"

        ./${name}
        ./configuration.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = specialArgs;
            users.frahz = {
              imports = homeProfile;
            };
          };
        }
        {
          networking.hostName = mkDefault name;
          nixpkgs.hostPlatform = mkDefault system;
        }
      ]
      ++ extraModules;
    };
in
{
  flake.nixosConfigurations = {
    anmoku = mkNixosSystem "anmoku" {
      homeProfile = homeImports.anmoku;
    };

    chibi = mkNixosSystem "chibi" {
      extraModules = [
        inputs.sugoi.nixosModules.default
        inputs.raulyrs.nixosModules.default
      ];
    };

    inari = mkNixosSystem "inari" { };
  };
}
