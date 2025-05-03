{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-home-assistant";
  version = "1.0.2-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "home-assistant";
    rev = "0277ab8a42751bcf97c49082e4b743ec32304571";
    hash = "sha256-+pVH2Ee7xII6B+rR5tu/9XoRzYdhnWGFvEpBLpvkyI8=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}
