{ config, lib, pkgs, ... }:

let
  cfg = config.features.research.xournalpp;
in {
  options.features.research.xournalpp.enable = lib.mkEnableOption "Xournal++ PDF annotator";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      xournalpp
    ];
  };
}
