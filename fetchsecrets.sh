#!/usr/bin/env bash
# credit to https://gist.github.com/arianvp/8f80c23a3410d27746fb97a6563d9677

token=$GITHUB_TOKEN

if [ -z "$token" ]; then
  nix run nixpkgs#gh auth status >&2 || \
  nix run nixpkgs#gh auth login <&2 >&2 # keep interaction
  token="$(nix run nixpkgs#gh auth token)"
fi

echo "access-tokens = github.com=$token"
