{ config, lib, ... }:

let
  cfg = config.features.cli.eza;
in {
  options.features.cli.eza.enable = lib.mkEnableOption "eza (modern ls)";

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      extraOptions = ["-l" "--icons" "--git" "-a"];
    };
  };
}
