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
      specialArgs ? { inherit inputs self system; },
    }:
    inputs.nixpkgs.lib.nixosSystem {
      # TODO: fix this workaround later
      inherit specialArgs;
      modules = [
        "${self}/modules/nixos"
        "${self}/users/frahz"

        ./${name}
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
    anmoku = mkNixosSystem "anmoku" { };

    chibi = mkNixosSystem "chibi" {
      extraModules = [
        inputs.sugoi.nixosModules.default
        inputs.raulyrs.nixosModules.default
      ];
    };

    inari = mkNixosSystem "inari" { };
  };
}
