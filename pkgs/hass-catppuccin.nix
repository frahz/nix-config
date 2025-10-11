{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-home-assistant";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "home-assistant";
    rev = "v${version}";
    hash = "sha256-sO9xuFzeQpJ3CpzcFGGZhFU9BbhlmI/PQih56EkJuug=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}
