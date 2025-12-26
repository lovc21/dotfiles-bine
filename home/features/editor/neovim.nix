{ config, lib, pkgs, ... }:

let
  cfg = config.features.editor.neovim;
in
{
  options.features.editor.neovim.enable = lib.mkEnableOption "neovim with LazyVim configuration";

  config = lib.mkIf cfg.enable {
    # Symlink your nvim config
    home.file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/jakob-stuff/dotfiles-bine/nvim";
      recursive = true;
    };
    
    # Install neovim and all required packages
    home.packages = with pkgs; [
      # Neovim
      neovim
      
      # Programming languages (needed for Mason to build LSPs)
      go
      cargo
      rustc
      
      # LSP servers (pre-installed, Mason can skip these)
      lua-language-server
      pyright
      nodePackages.typescript-language-server
      gopls
      bash-language-server
      terraform-ls
      nodePackages.vscode-langservers-extracted  # html, css, json
      tailwindcss-language-server
      zls  # Zig LSP
      
      # Formatters
      stylua
      black
      prettierd
      shfmt
      
      # Linters
      shellcheck
      
      # Tools
      ripgrep
      fd
      git
      xsel
      tree-sitter
      gcc
      lazygit
      
      # Mason dependencies
      unzip
      curl
      gzip
      gnutar
      wget
      gnumake
      cmake
      pkg-config
      
      # Node.js for LSPs
      nodejs_22
      
      # Clipboard support
      wl-clipboard
      xclip
    ];
    
    # Environment variables
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
