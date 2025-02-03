# MacOS Package and Settings Management with Nix

The command examples assume that the nix flake file is going to be stored in `~/.config/nix` .

To create a new flake file using the commands below.
```sh
cd ~/.config/nix
nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
```
This will create a `flake.nix` file.

Now add necessary configurations.

### Install nix-darwin tools

The directory containing the flake.nix file must be in the home directory.
```sh
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix
```

### Update Commands

The directory containing the flake.nix file must be in the home directory
```sh
cd ~/.config/nix
nix flake update
darwin-rebuild switch --flake  ~/.config/nix
```