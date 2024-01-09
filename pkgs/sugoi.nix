{ pkgs, lib, fetchFromGitHub, ... }:

pkgs.rustPlatform.buildRustPackage rec {
    pname = "sugoi";
    version = "0.1.0";

    src = fetchFromGitHub {
        owner = "frahz";
        repo = "sugoi";
        rev = "v${version}";
        hash = "";
    };

    cargoHash = "";

    meta = with lib; {
        description = "small web server for waking up and putting my server to sleep.";
        homepage = "https://git.iatze.cc/frahz/sugoi";
        changelog = "https://git.iatze.cc/frahz/sugoi/releases/tag/v${version}";
        license = licenses.mit;
        maintainers = [];
        mainProgram = "sugoi";
    };
}
