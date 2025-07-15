{
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "nemui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "frahz";
    repo = "nemui";
    rev = "v${version}";
    hash = "sha256-rbKSO0j0Fr3WcXzUSyYgcIqiQqgTg2Mzla1Et62HVQ0=";
  };

  cargoHash = "sha256-zP6ABfX8Jveei/v/2JSo98mvqiRs2kWObpa7jVjNimg=";

  meta = with lib; {
    description = "This utility is meant to run in the your main server. Once it receives a specific byte over it will put the server to sleep.";
    homepage = "https://git.iatze.cc/frahz/nemui";
    changelog = "https://git.iatze.cc/frahz/nemui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "nemui";
  };
}
