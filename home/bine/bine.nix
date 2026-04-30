{ config, lib, pkgs, ... }:

{
  imports = [
    ../common
    ../features
  ];

  home.username = lib.mkDefault "bine";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  
  # features enable/disable here
  features.cli = {
    zsh.enable = true;
    fzf.enable = true;
    bat.enable = true;
    eza.enable = true;
    zoxide.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    ai.enable = true;
    direnv.enable = true;
    atuin.enable = true;
    tools.enable = true;
  };

  features.git.enable = true;

  features.terminal = {
    ghostty.enable = true;
    alacritty.enable = true;
    xterm.enable = false;
    gnome-console.enable = false;
  };

  features.llms.ollama.enable = true;

  features.editor = {
    neovim.enable = true;
    vscode.enable = true;
  };

  features.desktop = {
    fonts.enable = true;
    hyprland.enable = true;
    wayland.enable = true;
    hyprpaper.enable = true;
    hyprlock.enable = true;
    hypridle.enable = true;
    communication.enable = true;
  };

  features.browsers = {
    firefox.enable = true;
    chromium.enable = true;
    google-chrome.enable = true;
    brave.enable = true;
  };

  features.music = {
    spotify.enable = true;
    gnome-music.enable = true;
    decibels.enable = true;
  };

  features.devops = {
    terraform.enable = true;
    kubernetes.enable = true;
    docker.enable = true;
    cloud.enable = true;
    hashicorp.enable = true;
    security.enable = true;
  };

  features.programming = {
    go.enable = true;
    python.enable = true;
    rust.enable = true;
    zig.enable = true;
    nodejs.enable = true;
    latex.enable = true;
  };

  features.vpn.protonvpn = {
    enable = true;
    useGui = true;
  };

  features.research = {
    zotero.enable = true;
    xournalpp.enable = true;
  };

  features.chess.enable = true;

  # GTK theme and icon theme
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  
  # GTK settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # random packages go here
  home.packages = with pkgs; [
    gnome-tweaks
    dconf-editor
  ];
}
