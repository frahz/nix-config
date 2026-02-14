{
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "hyprland-preview-share-picker";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "WhySoBad";
    repo = "hyprland-preview-share-picker";
    rev = "v${version}";
    hash = "sha256-LOHl7zCxTIDqHIZy8B/RZ76Phz/BKcdrNR4QhQkrcJA=";
    # fetchSubModules = true;
  };

  cargoHash = "sha256-AqX9jKj7JLEx1SLefyaWYGbRdk0c3H/NDTIsZy6B6hY=";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = with pkgs; [
    gdk-pixbuf
    gobject-introspection
    graphene
    gtk4
    gtk4-layer-shell
    hyprland-protocols
    pango
  ];
  preBuild = ''
    cp -r ${pkgs.hyprland-protocols}/share/hyprland-protocols/protocols lib/hyprland-protocols/
  '';

  meta = {
    description = "An alternative share picker for hyprland with window and monitor previews written in rust. Git version";
    homepage = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
