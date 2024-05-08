{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    # aylur's gtk shell
    ags.url = "github:Aylur/ags";

    # hyprlock for home-manager config
    hyprlock.url = "github:hyprwm/hyprlock?ref=main";

    # realtime audio
    musnix.url = "github:musnix/musnix";

    # neorg overlay for up-to-date neorg stuff
    neorg.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    # updated minecraft servers
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # ai
    nixified-ai.url = "github:nixified-ai/flake";

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # latest wayland packages
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # neovim config in nix
    nixvim.url = "github:nix-community/nixvim";

    # node.js debugging
    vscode-js-debug = {
      url = "github:microsoft/vscode-js-debug";
      flake = false;
    };

    # for runtime-decrypted secrets
    sops-nix.url = "github:Mic92/sops-nix";

    # database for muni_bot
    surrealdb.url = "github:surrealdb/surrealdb?ref=v1.4.0";

    # my stuff
    iosevka-muse.url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
    muni-bot.url = "github:muni-corn/muni_bot";
    muse-sounds.url = "git+https://codeberg.org/municorn/muse-sounds?ref=main";
    muni-wallpapers = {
      url = "github:muni-corn/muni-wallpapers";
      flake = false;
    };
    plymouth-theme-musicaloft-rainbow.url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ags,
    hyprlock,
    iosevka-muse,
    muni-bot,
    muni-wallpapers,
    muse-sounds,
    musnix,
    neorg,
    nix-minecraft,
    nixified-ai,
    nixos-hardware,
    nixpkgs-wayland,
    nixvim,
    plymouth-theme-musicaloft-rainbow,
    sops-nix,
    surrealdb,
    vscode-js-debug,
  } @ inputs: let
    lockFile = nixpkgs.lib.importJSON ./flake.lock;

    overlaysModule = {
      nixpkgs.overlays = [
        iosevka-muse.overlay
        muse-sounds.overlay
        neorg.overlays.default
        nix-minecraft.overlay
        nixpkgs-wayland.overlays.default
        plymouth-theme-musicaloft-rainbow.overlay
        hyprlock.overlays.default
      ];
    };

    binaryCachesModule = {
      nix.settings = {
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://nixpkgs-wayland.cachix.org"
          "https://hyprland.cachix.org"
        ];
      };
    };

    commonModules = [
      binaryCachesModule
      home-manager.nixosModules.home-manager
      musnix.nixosModules.musnix
      overlaysModule
      {
        home-manager = {
          backupFileExtension = "backup";
          extraSpecialArgs = {
            inherit muni-wallpapers;
            vscode-js-debug-src = vscode-js-debug;
          };
          sharedModules = [
            ags.homeManagerModules.default
            hyprlock.homeManagerModules.default
            nixvim.homeManagerModules.nixvim
          ];
          useGlobalPkgs = true;
          useUserPackages = true;
          users.muni = ./muni;
        };
      }
    ];

    littleponyHardwareModules = with nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      common-pc-laptop
      common-pc-laptop-hdd
    ];

    # note: we would include common-pc-hdd, but it only sets vm.swappiness to
    # 10, which is overriden by common-pc-ssd, which sets vm.swappiness to 1.
    # swap on ponycastle is currently restricted to the ssd.
    ponycastleModules = with nixos-hardware.nixosModules; [
      # hardware
      common-cpu-amd
      common-gpu-amd
      common-pc
      common-pc-ssd

      # extra software configuration modules
      nixified-ai.nixosModules.invokeai-amd
      muni-bot.nixosModules.default
    ];
  in {
    nixosConfigurations = {
      littlepony = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = commonModules ++ littleponyHardwareModules ++ [./laptop];
      };
      ponycastle = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = commonModules ++ ponycastleModules ++ [./desktop];
      };
    };
  };
}
