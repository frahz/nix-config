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
      # TODO: until https://github.com/NixOS/nixpkgs/issues/360592 is resolved
      permittedInsecurePackages = [
        "aspnetcore-runtime-6.0.36"
        "aspnetcore-runtime-wrapped-6.0.36"
        "dotnet-runtime-6.0.36"
        "dotnet-runtime-wrapped-6.0.36"
        "dotnet-sdk-6.0.428"
        "dotnet-sdk-wrapped-6.0.428"
      ];
    };
  };

}
