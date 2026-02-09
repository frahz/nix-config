{ self, ... }:
let
  overlay-local = import "${self}/pkgs";
in
{
  nixpkgs = {
    overlays = [
      overlay-local
      (final: prev: {
        python313Packages = prev.python313Packages.override {
          overrides = pythonFinal: pythonPrev: {
            universal-silabs-flasher = pythonPrev.universal-silabs-flasher.overridePythonAttrs (old: {
              doCheck = false;
            });
            zigpy = pythonPrev.zigpy.overridePythonAttrs (old: {
              doCheck = false;
            });
            bellows = pythonPrev.bellows.overridePythonAttrs (old: {
              doCheck = false;
            });
          };
        };
      })
    ];
    config = {
      allowUnfree = true;
      # allowAliases = false;
      permittedInsecurePackages = [ ];
    };
  };

}
