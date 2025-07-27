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
      permittedInsecurePackages = [ ];
    };
  };

}
