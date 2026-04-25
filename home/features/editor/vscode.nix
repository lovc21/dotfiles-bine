{ config, lib, pkgs, ... }:

let
  cfg = config.features.editor.vscode;
in {
  options.features.editor.vscode.enable = lib.mkEnableOption "VS Code";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode
    ];
  };
}
