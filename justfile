flake := env("NH_FLAKE", justfile_directory())
args := "--sudo --ask-sudo-password --no-reexec --log-format internal-json"

[private]
default:
  @just --list --unsorted

# update all inputs
update:
  nix flake update

# deploy config to server
deploy host:
  nixos-rebuild switch \
    --flake {{flake}}#{{host}} \
    --target-host {{host}} \
    --build-host {{host}} \
    {{args}} \
    --use-substitutes \
    |& nom --json

# clean nix store
clean:
    nix-collect-garbage --delete-older-than 3d
    nix store optimise
