{ pkgs, lib, fetchFromGitHub, ... }:

pkgs.rustPlatform.buildRustPackage rec {
    pname = "nemui";
    version = "0.1.0";

    src = fetchFromGitHub {
        owner = "frahz";
        repo = "nemui";
        rev = "v${version}";
        hash = "sha256-MBoBHc1TQgMwzImBdKxPcSFSwMdxUwCkcQwThynaWbk=";
    };

    cargoHash = "sha256-ffJi+n9ZQSr7MkLmL8It+4yXxfbnhwvCl/O2zjfMqpA=";

    meta = with lib; {
        description = "This utility is meant to run in the your main server. Once it receives a specific byte over it will put the server to sleep.";
        homepage = "https://git.iatze.cc/frahz/nemui";
        changelog = "https://git.iatze.cc/frahz/nemui/releases/tag/v${version}";
        license = licenses.mit;
        maintainers = [];
        mainProgram = "nemui";
    };
}
