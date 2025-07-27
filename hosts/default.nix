{
  self,
  inputs,
  ...
}:
let

  homeImports = import "${self}/home/profiles";

  mkNixosSystem =
    name:
    {
      system ? "x86_x64-linux",
      extraModules ? [ ],
      homeProfile ? homeImports.default,
      specialArgs ? { inherit inputs self system; },
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        "${self}/modules/nixos"

        ./${name}
        ./configuration.nix
        inputs.catppuccin.nixosModules.catppuccin
        inputs.home.nixosModules.home-manager
        inputs.sops-nix.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = specialArgs;
            users.frahz = {
              imports = homeProfile;
            };
          };
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
