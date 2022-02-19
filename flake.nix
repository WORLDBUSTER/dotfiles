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
    muse-status = {
      url = "git+https://codeberg.org/municorn/muse-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hotpot.nvim plugin
    hotpot-nvim = {
      url = "github:rktjmp/hotpot.nvim";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-next
    , home-manager
    , hotpot-nvim
    , iosevka-muse
    , muse-sounds
    , muse-status
    , neovim-nightly-overlay
    , plymouth-theme-musicaloft-rainbow
    }:
    let
      vimPluginOverlay = final: prev:
        let
          lock = builtins.fromJSON (builtins.readFile ./flake.lock);
          hotpotLock = lock.nodes.hotpot-nvim.locked;
        in
        {
          vimPlugins = prev.vimPlugins // {
            hotpot-nvim = prev.vimUtils.buildVimPlugin {
              name = "hotpot.nvim";
              src = prev.fetchFromGitHub {
                inherit (hotpotLock) owner repo rev;
                sha256 = hotpotLock.narHash;
              };
            };
          };
        };

      kittyOverlay = final: prev:
        let next-pkgs = import nixpkgs-next { inherit (prev) system; }; in
        {
          kitty = next-pkgs.kitty;
        };

      overlaysModule = { config, lib, pkgs, ... }: {
        nixpkgs.overlays = [
          iosevka-muse.overlay
          kittyOverlay
          muse-sounds.overlay
          muse-status.overlay
          neovim-nightly-overlay.overlay
          plymouth-theme-musicaloft-rainbow.overlay
          vimPluginOverlay
        ];
      };
      extraModules = [
        overlaysModule
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.municorn = import ./homes/muni/home.nix;
          };
        }
      ];
    in
    {
      nixosConfigurations.littlepony = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = extraModules ++ [ ./laptop-configuration.nix ];
      };
      nixosConfigurations.ponytower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = extraModules ++ [ ./desktop-configuration.nix ];
      };
    };
}
