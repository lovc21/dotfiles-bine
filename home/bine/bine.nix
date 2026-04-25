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
    fastfetch.enable = true;
    starship.enable = true;
    ai.enable = true;
    direnv.enable = true;
    atuin.enable = true;
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

  # Enable VPN
  features.vpn.protonvpn = {
    enable = true;
    useGui = true;
  };

  # Theming (gtk, qt, cursor, dark mode) is handled by Stylix —
  # see hosts/bine/stylix.nix. Papirus icon theme is not a Stylix target
  # so we set it explicitly.
  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
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
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))
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
    prettier
    typescript-language-server
    
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
