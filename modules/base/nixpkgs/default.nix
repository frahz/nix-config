{ self, ... }:
let
  overlay-local = import "${self}/pkgs";
in
{
  nixpkgs = {
    overlays = [
      overlay-local
      (final: prev: {
        # https://github.com/NixOS/nixpkgs/issues/562919
        linux-firmware = prev.linux-firmware.overrideAttrs (_: {
          version = "20260810";
          src = final.fetchFromGitLab {
            owner = "kernel-firmware";
            repo = "linux-firmware";
            tag = "20260810";
            hash = "sha256-P/fPpqaatp8Z2GV+I/OChiWGn6AhV+8w1RMFuX/LqHc=";
          };
        });
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
