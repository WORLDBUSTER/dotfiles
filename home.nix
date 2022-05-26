{ config, deviceInfo ? null, lib, overlays ? [ ], pkgs, ... }:

{
  imports = [
    ./muse
    ./muse-status.nix
    ./nvim
  ] ++ (lib.optional pkgs.stdenv.isLinux ./linux);

  nixpkgs = {
    inherit overlays;
    config = import ./config.nix { inherit lib; };
  };

  accounts.email = import ./email/mod.nix { inherit config; };

  home = {
    enableNixpkgsReleaseCheck = true;

    extraOutputsToInstall = [ "doc" "info" "devdoc" ];

    file = {
      ".vsnip" = {
        recursive = true;
        source = ./vsnip;
      };
      ".rustfmt.toml" = {
        source = ./rustfmt.toml;
      };
      ".npmrc" = {
        source = ./npmrc;
      };
    };

    packages = with pkgs;
      # packages for all devices
      [
        # terminal/cli stuff
        fd
        gnupg
        neovim-remote
        nixpkgs-fmt
        ripgrep
        sd

        # fish plugins
        fishPlugins.done
        fishPlugins.foreign-env
      ] ++

      # for personal devices
      lib.optionals (deviceInfo.personal) [
        # development/programming
        rnix-lsp
        rustup
        rust-analyzer
        tree-sitter
        zls

        # email
        hydroxide

        # other terminal/cli stuff
        fnlfmt
        git-annex
        git-crypt
        glances
        libqalculate
        pv
        rsync
        spotify-tui
        tldr
        unar
        yt-dlp
        zip
      ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };

  manual.html.enable = true;

  programs = import ./programs.nix {
    inherit config deviceInfo lib pkgs;
  };

  services = import ./services.nix {
    inherit deviceInfo lib pkgs;
  };
}

# vim: ts=2 sw=2 expandtab
