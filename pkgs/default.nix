self: super: {
  hyprland-preview-share-picker = self.callPackage ./hyprland-preview-share-picker.nix { };
  smartrent-py = self.python3.pkgs.callPackage ./smartrent-py.nix { };
  hass-smartrent = self.home-assistant.python.pkgs.callPackage ./hass-smartrent.nix { };
  hass-catppuccin = self.callPackage ./hass-catppuccin.nix { };
  hayase = self.callPackage ./hayase.nix { };
}
