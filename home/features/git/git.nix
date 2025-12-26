{ config, lib, pkgs, ... }:

let
  cfg = config.features.git;
in
{
  options.features.git.enable = lib.mkEnableOption "git configuration";

  config = lib.mkIf cfg.enable {
    # Install git and related tools
    home.packages = with pkgs; [
      git
      git-lfs
      delta
      gh
      
      # YubiKey support
      yubikey-manager
      yubikey-personalization
    ];
    
    # Symlink git configs
    home.file.".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/jakob-stuff/dotfiles-bine/git-config/gitconfig";
    };
    
    home.file.".gitconfig-personal" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/jakob-stuff/dotfiles-bine/git-config/gitconfig-personal";
    };
    
    home.file.".gitconfig-work" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/jakob-stuff/dotfiles-bine/git-config/gitconfig-work";
    };
    
    # GPG configuration for YubiKey
    programs.gpg = {
      enable = true;
      settings = {
        # YubiKey specific settings
        use-agent = true;
      };
    };
    
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-curses;
      extraConfig = ''
        # YubiKey support
        enable-ssh-support
      '';
    };
  };
}
