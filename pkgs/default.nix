self: super: {
  hyprland-preview-share-picker = self.callPackage ./hyprland-preview-share-picker.nix { };
  hass-catppuccin = self.callPackage ./hass-catppuccin.nix { };
}
