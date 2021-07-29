{ config, pkgs, ... }:

{
  user = {
    sessionVariables = let
      homeDir = config.home.homeDirectory;
    in {
      HOME = homeDir;
      CARGO_PATH = "${homeDir}/.cargo/bin/";
    };
    services = {
      hydroxide = {
        Unit = {
          Description = "hydroxide serve";
        };

        Service = {
          ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
          Restart = "always";
          RestartSec = 10;
        };

        Install = {
          WantedBy = [ "multi-user.target" ];
        };
      };

      muse-status-daemon = {
        Unit = {
          Description = "muse-status daemon";
        };

        Service = {
          ExecStart = "/home/muni/.cargo/bin/muse-status-daemon";
        };

        Install = {
          WantedBy = [ "multi-user.target" ];
        };
      };
    };
  };
}
