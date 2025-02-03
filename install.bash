#!/bin/bash

sh <(curl -L https://nixos.org/nix/install)

# install pkgs from flake
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/.config/nix#macbook
