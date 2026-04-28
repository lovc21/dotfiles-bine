{ config, lib, pkgs, ... }:

let
  cfg = config.features.git;
in
{
  options.features.git.enable = lib.mkEnableOption "git configuration";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      git-lfs
      delta
      gh
      glab
      lazygit
      diffuse
      netcat

      # YubiKey support
      yubikey-manager
      yubikey-personalization
      yubikey-agent
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

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = "~/.ssh/id_ed25519_sk_rk";
          identitiesOnly = true;
          proxyCommand = "sh -c 'nc -w 3 -z github.com 22 >/dev/null 2>&1 && exec nc %h 22 || exec nc ssh.github.com 443'";
        };
        "gist.github.com" = {
          user = "git";
          identityFile = "~/.ssh/id_ed25519_sk_rk";
          identitiesOnly = true;
          proxyCommand = "sh -c 'nc -w 3 -z github.com 22 >/dev/null 2>&1 && exec nc %h 22 || exec nc ssh.github.com 443'";
        };
      };
    };
  };
}
