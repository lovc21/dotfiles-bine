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

  # Enable CLI
  features.cli = {
    zsh.enable = true;
    fzf.enable = true;
    bat.enable = true;
    eza.enable = true;
    zoxide.enable = true;
    neofetch.enable = true;
    starship.enable = true;
    ai.enable = true;
  };
  
  # Enable git config
  features.git.enable = true;

  # Enable terminal ghossty
  features.terminal.ghostty.enable = true;

  # Enable nvim
  features.editor.neovim.enable = true;

  # Enable desktop
  features.desktop = {
    fonts.enable = true;
    hyprland.enable = true;
    wayland.enable = true;
    hyprpaper.enable = true;
    hyprlock.enable = true;
    hypridle.enable = true;
  };

  # Set Tokyo Night as default theme
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Enable Qt
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  home.packages = with pkgs; [
  
    # === TERMINALS ===
    alacritty
    
    # === SHELL ===
    starship
    
    # === CORE CLI UTILITIES ===
    jq
    yq-go
    bottom
    fastfetch
    duf
    dust
    sd
    ripgrep-all

    # === DEVOPS & INFRASTRUCTURE ===
    terraform
    terraform-ls
    tflint
    
    # Kubernetes tools
    kubectl
    kubectx
    k9s
    helm
    argocd
    
    # Docker tools
    docker-compose
    lazydocker
    lazygit
    dive
    
    # Cloud tools
    google-cloud-sdk
    awscli2
    
    # HashiCorp stuff
    packer
    vault
    ansible
    
    # === PROGRAMMING LANGUAGES ===
    # Go
    go
    gopls
    golangci-lint
    delve
    
    # Python
    pipx
    python312
    python312Packages.pip
    pyright
    ruff
    
    # Zig
    zig
    
    # Rust
    rustc
    cargo
    rust-analyzer
    
    # Node.js
    nodejs_22
    nodePackages.prettier
    nodePackages.typescript-language-server
    
    # === MONITORING & DEBUGGING ===
    htop
    iotop
    nethogs
    nmap
    tcpdump
    wireshark
    dig
    
    # === FILE MANAGEMENT ===
    yazi
    ranger
    unzip
    zip
    just

    # === THEMES ===  
    tokyonight-gtk-theme
    papirus-icon-theme
    # tela-circle-icon-theme
    bibata-cursors
      
    # === BROWSERS ===
    chromium
    google-chrome
    brave
    firefox

    # === COMMUNICATION ===
    slack
    discord
    
    # === MUSIC ===
    spotify

    # === SECURITY ===
    grype
    trivy
    age
    sops

    # === UTILITIES ===
    rsync
    rclone
    tldr
    xclip
    tokei
    hyperfine
    glow
    slides
    ollama

    # === EDITORS ===
    vscode

    # === MISC ===
    gnome-tweaks
    dconf-editor
  ];
}
