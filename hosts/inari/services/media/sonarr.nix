{config, ...}: let
  cfg = config.media;
in {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = "${cfg.storage}/containers/sonarr/config";
    user = "frahz";
    group = "media";
  };

  # TODO: until https://github.com/NixOS/nixpkgs/issues/360592 is resolved
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];
}
