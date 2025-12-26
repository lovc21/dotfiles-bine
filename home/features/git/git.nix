{ config, lib, pkgs, ... }:

let
  cfg = config.features.git;
in {
  options.features.git.enable = lib.mkEnableOption "git configuration";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      
      # Updated syntax for user settings
      settings = {
        user = {
          name = "Jakob";
          email = "jakob.dekleva@gmail.com";
        };
        
        commit = {
          gpgsign = true;
        };
        
        gpg = {
          program = "${pkgs.gnupg}/bin/gpg";
        };
        
        # Include work config conditionally
        includeIf."gitdir:~/devrev/" = {
          path = "~/.gitconfig-work";
        };
        
        # Include personal config conditionally
        includeIf."gitdir:~/jakob/" = {
          path = "~/.gitconfig-personal";
        };
        
        includeIf."gitdir:~/jakob-stuff/" = {
          path = "~/.gitconfig-personal";
        };
      };
    };

    # Delta moved to separate program
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
    };

    # GPG configuration
    programs.gpg = {
      enable = true;
    };
    
    # Updated syntax for pinentry
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };
}
