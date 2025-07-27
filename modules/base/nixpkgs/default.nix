{ self, ... }:
let
  overlay-local = import "${self}/pkgs";
in
{
  nixpkgs = {
    overlays = [
      overlay-local
    ];
    config = {
      allowUnfree = true;
      # allowAliases = false;
      permittedInsecurePackages = [
        "dotnet-runtime-6.0.36"
      ];
    };
  };

}
