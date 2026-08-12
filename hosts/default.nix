{
  lib,
  self,
  inputs,
  withSystem,
  ...
}:
let
  inherit (lib) mkDefault;

  mkNixosSystem =
    name:
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
    }:
    withSystem system (
      { inputs', ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs inputs' self; };
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
      }
    );
in
{
  flake = {
    nixosConfigurations = {
      anmoku = mkNixosSystem "anmoku" { };

      chibi = mkNixosSystem "chibi" { };

      desktop = mkNixosSystem "desktop" {
        extraModules = [
          "${self}/modules/wsl"
        ];
      };

      inari = mkNixosSystem "inari" { };

      shintaku = mkNixosSystem "shintaku" {
        system = "aarch64-linux";
      };
    };
    darwinConfigurations = {
      kaze = withSystem "aarch64-darwin" (
        { inputs', ... }:
        inputs.darwin.lib.darwinSystem {
          specialArgs = { inherit inputs inputs' self; };
          modules = [
            "${self}/modules/darwin"
            "${self}/users/frahz"

            ./kaze
            {
              nixpkgs.hostPlatform = mkDefault "aarch64-darwin";
            }
          ];
        }
      );
    };
  };
}
