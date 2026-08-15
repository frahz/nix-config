{ inputs, lib, ... }:
{
  imports = lib.lists.singleton inputs.hjem.nixosModules.default;
}
