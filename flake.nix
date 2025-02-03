{
  description = "Eric Macbook Setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { config, pkgs, ... }: {
        # Install packages
        environment.systemPackages = [
          pkgs.wezterm
          pkgs.neovim
          pkgs.vim
        ];
        
        homebrew = {
          enable = true;
          brews = [
            # this cli tool help find app store id of apps
            # cmd eg.: mas search firefox
            # the first item in the list is the id
            "mas"
          ];
          casks = ["firefox"];

          # dict of Mac appstore apps to install
          # each item is "<app_name>" = "<app_store_id>"
          # !! must already be signed into the appstore and have purchased the app
          # masApps = {
          # }

          # cause nix to remove brew packages not in this list automatically
          # onActivation.cleanup  = "zap";
        };

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Necessary for using flakes on this system
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin
        programs.zsh.enable = true;

        # System configuration revision
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # macOS settings
        system.defaults = {
          dock.autohide = true;
          NSGlobalDomain.AppleICUForce24HourTime = true;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
          NSGlobalDomain.KeyRepeat = 2;
        };

        # Used for backwards compatibility
        system.stateVersion = 6;
      };
  in
    {
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "erolleman";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."macbook".pkgs;
    };
}
