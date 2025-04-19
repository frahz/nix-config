{
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "hyprland-preview-share-picker";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "WhySoBad";
    repo = "hyprland-preview-share-picker";
    rev = "v${version}";
    hash = "sha256-Ijp8pOqrrL4FLQ7yIfFrAUwe/8R82WcbP6XQhOsFwlw=";
    # fetchSubModules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-I2dVxRfx0IiXiiLy4ygx5gvtJrf+YHJ4P7Cvq51dIrU=";

  nativeBuildInputs = [pkgs.pkg-config];
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
