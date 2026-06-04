self: super: {
  hyprland-preview-share-picker = self.callPackage ./hyprland-preview-share-picker.nix { };
  smartrent-py = self.python3Packages.callPackage ./smartrent-py.nix { };
  hass-smartrent = self.home-assistant.python3Packages.callPackage ./hass-smartrent.nix { };
  hass-catppuccin = self.callPackage ./hass-catppuccin.nix { };
}
