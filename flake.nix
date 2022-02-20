{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-next.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plymouth-theme-musicaloft-rainbow = {
      url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iosevka-muse = {
      url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muse-sounds = {
      url = "git+https://codeberg.org/municorn/muse-sounds";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my home sweet home
    municorn-home = {
      url = "git+https://codeberg.org/municorn/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-next
    , municorn-home
    , home-manager
    , iosevka-muse
    , muse-sounds
    , neovim-nightly-overlay
    , plymouth-theme-musicaloft-rainbow
    }:
    let

      nextOverlay = final: prev:
        let next-pkgs = import nixpkgs-next { inherit (prev) system; }; in
        {
          inherit (next-pkgs) kitty remarshal;
        };

      overlaysModule = { config, lib, pkgs, ... }: {
        nixpkgs.overlays = [
          iosevka-muse.overlay
          nextOverlay
          muse-sounds.overlay
          plymouth-theme-musicaloft-rainbow.overlay
        ];
      };
      extraModules = [
        overlaysModule
      ];
    in
    {
      nixosConfigurations = {
        littlepony = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = extraModules ++ [ ./laptop-configuration.nix ];
        };
        ponytower = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = extraModules ++ [ ./desktop-configuration.nix ];
        };
      };
      homeConfigurations = {
        inherit (municorn-home.homeConfigurations) municorn;
      };
    };
}
