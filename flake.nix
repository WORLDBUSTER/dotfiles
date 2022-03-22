{
  description = "Home configuration for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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

    # iosevka muse
    iosevka-muse = {
      url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # muse-status
    muse-status = {
      url = "git+https://codeberg.org/municorn/muse-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # muse-sounds
    muse-sounds = {
      url = "git+https://codeberg.org/municorn/muse-sounds";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, hotpot-nvim, iosevka-muse, muse-status, muse-sounds }: {
    homeConfigurations =
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
        overlays = [
          neovim-nightly-overlay.overlay
          iosevka-muse.overlay
          muse-sounds.overlay
          muse-status.overlay
          vimPluginOverlay
        ];

        username = "municorn";
        homePath = "/home/${username}";
        homeConfiguration = deviceName: home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = homePath;
          username = username;
          stateVersion = "21.11";
          extraSpecialArgs = { inherit overlays deviceName; };
          configuration = import ./home.nix;
        };
      in
      {
        ponytower = homeConfiguration "ponytower";
        littlepony = homeConfiguration "littlepony";
      };
  };
}
