{ self, ... }:
let
  overlay-local = import "${self}/pkgs";
in
{
  nixpkgs = {
    overlays = [
      overlay-local
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (pythonFinal: pythonPrev: {
            # nanoemoji = pythonPrev.nanoemoji.overridePythonAttrs (old: {
            #   src = old.src.override {
            #     hash = "sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=";
            #   };
            # });
          })
        ];
      })
    ];
    config = {
      allowUnfree = true;
      allowAliases = true;
      permittedInsecurePackages = [ ];
    };
  };

}
