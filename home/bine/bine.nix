{ config, lib, pkgs, ... }:

{
  home.username = lib.mkDefault "bine";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "25.11";
  
  home.packages = [];
  home.file = {};
  home.sessionVariables = {};
  
  programs.home-manager.enable = true;
}
