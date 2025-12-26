{ config, lib, ... }:

let
  cfg = config.features.cli.zoxide;
in {
  options.features.cli.zoxide.enable = lib.mkEnableOption "zoxide (smarter cd)";

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
