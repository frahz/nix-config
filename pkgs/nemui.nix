{
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "nemui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "nemui";
    rev = "v${version}";
    hash = "sha256-zvLHHvEAj1uA7BOr+As7T5BfHtgTVwZBEm7cwHA0ORo=";
  };

  cargoHash = "sha256-6wyIVtJv7CkNl5GL+ymzwDQ3ry84XyojgBlS/H2VPUI=";

  meta = with lib; {
    description = "This utility is meant to run in the your main server. Once it receives a specific byte over it will put the server to sleep.";
    homepage = "https://git.iatze.cc/frahz/nemui";
    changelog = "https://git.iatze.cc/frahz/nemui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "nemui";
  };
}
