{ config, lib, ... }:

let
  cfg = config.features.cli.bat;
in {
  options.features.cli.bat.enable = lib.mkEnableOption "bat (better cat)";

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        pager = "less -FR";
      };
    };
  };
}
