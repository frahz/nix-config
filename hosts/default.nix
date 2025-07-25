{
  self,
  inputs,
  homeImports,
  ...
}:
let
  hm-module = inputs.home.nixosModules.home-manager;
  sops-module = inputs.sops-nix.nixosModules.default;
  sugoi-module = inputs.sugoi.nixosModules.default;
  raulyrs-module = inputs.raulyrs.nixosModules.default;
  catppuccin-module = inputs.catppuccin.nixosModules.catppuccin;

  mkNixosSystem =
    name:
    {
      extraModules ? [ ],
      homeProfile ? homeImports.default,
      specialArgs ? { inherit inputs self; },
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = [
        ./${name}
        ./configuration.nix
        catppuccin-module
        hm-module
        sops-module
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
      homeProfile = homeImports."frahz@desktop";
    };

    chibi = mkNixosSystem "chibi" {
      extraModules = [
        raulyrs-module
        sugoi-module
      ];
    };

    inari = mkNixosSystem "inari" { };
  };
}
