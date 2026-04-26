{ config, lib, pkgs, ... }:

let
  cfg = config.features.research.zotero;
in {
  options.features.research.zotero.enable = lib.mkEnableOption "Zotero reference manager";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zotero
    ];
  };
}
