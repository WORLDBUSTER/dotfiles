/* Applies opinionated theming based on a base16 color scheme
*/
{ config, lib, pkgs, ... }:

let
  paletteLib = import ../palette.nix { inherit lib; };
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (types) mkOptionType;
  inherit (paletteLib) paletteType mkSwatch;

  fontType = types.submodule
    {
      options = {
        package = mkOption {
          type = types.package;
          description = "The package supplying the font.";
        };
        name = mkOption {
          type = types.str;
          description = "The font family name.";
        };
        size = mkOption {
          type = types.ints.positive;
          description = "The point size of the font.";
        };
      };
    };
in
{
  options.muse.theme = {
    enable = mkEnableOption "Muse theming for a variety of apps";
    colors = mkOption {
      type = paletteType;
      description = "The color theme to use for theming.";
      apply = mkSwatch;
    };
    sansFont = mkOption {
      type = fontType;
      description = "Default sans-serif font to use.";
      default = {
        package = pkgs.inter;
        name = "Inter";
        size = 12;
      };
    };
    codeFont = mkOption {
      type = fontType;
      description = "Default monospace font to use.";
      default = {
        package = pkgs.iosevka-muse.normal;
        name = "Iosevka Muse";
        size = 12.0;
      };
    };
    wallpapers = mkOption {
      type = types.submodule {
        options = {
          dir = mkOption {
            type = types.nullOr types.path;
            description = "A path containing wallpapers.";
            default = null;
          };
          useMatchpal = mkEnableOption "matchpal theming for wallpapers. Will use <option>muse.theme.colors</option> for colors";
          finalWallpapers = mkOption {
            type = types.path;
            description = "The final directory containing potentially processed wallpapers.";
            readOnly = true;
          };
        };
      };
      description = "Settings for wallpapers.";
    };
  };
  config =
    let
      cfg = config.muse.theme;

      wallpapersPath = builtins.path {
        name = "wallpapers";
        path = cfg.wallpapers.dir;
      };

      paletteFile = pkgs.writeTextFile {
        name = "matchpal-palette";
        text = ''
          ${cfg.colors.base00}
          ${cfg.colors.base01}
          ${cfg.colors.base02}
          ${cfg.colors.base03}
          ${cfg.colors.base04}
          ${cfg.colors.base05}
          ${cfg.colors.base06}
          ${cfg.colors.base07}
          ${cfg.colors.base08}
          ${cfg.colors.base09}
          ${cfg.colors.base0A}
          ${cfg.colors.base0B}
          ${cfg.colors.base0C}
          ${cfg.colors.base0D}
          ${cfg.colors.base0E}
          ${cfg.colors.base0F}
        '';
      };
    in
    mkIf cfg.enable {
      muse.theme.wallpapers.finalWallpapers = mkIf (cfg.wallpapers.dir != null)
        (if cfg.wallpapers.useMatchpal then
          pkgs.stdenv.mkDerivation
            {
              name = "muse-matchpal-wallpapers";
              src = wallpapersPath;
              dontConfigure = true;
              buildPhase = ''
                mkdir -p $out

                for wallpaper in ${wallpapersPath}/*
                do
                  name=$(basename $wallpaper)
                  echo "changing palette for $name"
                  ${pkgs.matchpal}/bin/matchpal --palette ${paletteFile} --input $wallpaper --output $out/$name
                done
              '';
              dontInstall = true;
            } else wallpapersPath);
    };
}
