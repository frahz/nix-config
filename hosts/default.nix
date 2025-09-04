{
  lib,
  self,
  inputs,
  ...
}:
let
  inherit (lib) mkDefault;

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
  flake = {
    nixosConfigurations = {
      anmoku = mkNixosSystem "anmoku" { };

      chibi = mkNixosSystem "chibi" {
        extraModules = [
          inputs.paquetes.nixosModules.sugoi
          inputs.paquetes.nixosModules.raulyrs
        ];
      };

      inari = mkNixosSystem "inari" { };
    };
    darwinConfigurations = {
      kaze = inputs.darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          "${self}/modules/darwin"
          "${self}/users/frahz"

          ./kaze
          {
            nixpkgs.hostPlatform = mkDefault "aarch64-darwin";
          }
        ];
      };
    };
  };
}
