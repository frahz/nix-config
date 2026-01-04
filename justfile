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

[group('dev')]
[no-exit-message]
repl-host host=`hostname`:
  nix repl .#nixosConfigurations.{{ host }}

# rotate all secrets
[group('dev')]
[no-exit-message]
rotate-secrets:
  find secrets/ -name "*.yaml" | xargs -I {} sops rotate -i {}

# update the secret keys
[group('dev')]
[no-exit-message]
update-secrets:
  find secrets/ -name "*.yaml" | xargs -I {} sops updatekeys -y {}

# clean nix store
clean:
  nix-collect-garbage --delete-older-than 3d
  nix store optimise

