{ config, lib, pkgs, ... }:

let
  cfg = config.features.cli.zsh;
in
{
  options.features.cli.zsh = {
    enable = lib.mkEnableOption "zsh shell configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Oh My Zsh configuration
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "docker"
          "web-search"
        ];
      };

      # Shell aliases
      shellAliases = {
        ls = "eza --icons --color=always --group-directories-first";
        l = "eza --icons --color=always --group-directories-first --git-ignore";
        ll = "eza --icons --color=always --group-directories-first --all --header --long";
        llm = "eza --icons --color=always --group-directories-first --all --header --long --sort=modified";
        la = "eza --icons --color=always --group-directories-first -lbhHigUmuSa";
        lx = "eza --icons --color=always --group-directories-first -lbhHigUmuSa@";
        lt = "eza --icons --color=always --group-directories-first --tree";
        tree = "eza --icons --color=always --group-directories-first --tree";
        lsg = "eza --icons --color=always --group-directories-first --grid";

        # Lazy tools
        lzd = "lazydocker";
        lzg = "lazygit";

        # System management
        update = "sudo nixos-rebuild switch";
      };

      # History configuration
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignoreDups = true;
        share = true;
      };

      # Environment variables from .zshrc
      sessionVariables = {
        # Go configuration
        GOROOT = "/usr/local/go";
        GOPATH = "$HOME/go";

        # GKE auth plugin
        USE_GKE_GCLOUD_AUTH_PLUGIN = "True";

        # GPG TTY
        GPG_TTY = "$(tty)";
      };

      # Changed from initExtra to initContent
      initContent = ''
        # FZF configuration
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
        if command -v fzf >/dev/null 2>&1; then
          source <(fzf --zsh)
        fi

        # Zoxide initialization (better cd)
        if command -v zoxide >/dev/null 2>&1; then
          eval "$(zoxide init --cmd cd zsh)"
        fi

        # Rust environment
        [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

        # ASDF version manager
        [ -f "$HOME/.asdf/asdf.sh" ] && source "$HOME/.asdf/asdf.sh"

        # NVM (Node Version Manager)
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        # Pay Respects (better thefuck)
        if command -v pay-respects >/dev/null 2>&1; then
          eval "$(pay-respects zsh --alias)"
        fi

        # Additional PATH additions
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.tfenv/bin:$PATH"
        export PATH="$GOROOT/bin:$PATH"
        export PATH="$GOPATH/bin:$PATH"

        # Ghostty path (from dotfiles)
        export PATH="$PATH:/home/jakob/Downloads/ghostty-1.0.0/zig-out/bin"

        # Neovim path (from dotfiles)
        export PATH="$PATH:~/Downloads/nvim-linux64/bin"
      '';

      # Plugins autosuggestions and syntax highlighting
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
          file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
          file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        }
      ];
    };

    # Install required CLI packages from dotfiles
    home.packages = with pkgs; [
      eza           # Modern ls replacement
      bat           # Better cat
      fzf           # Fuzzy finder
      zoxide        # Better cd command
      ripgrep       # Better grep
      fd            # Better find

      zsh-autosuggestions
      zsh-syntax-highlighting
      oh-my-zsh
    ];
  };
}
