{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.bine = {
    isNormalUser = true;
    description = "jakob";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ 

      # === Add home-manager package ===
      inputs.home-manager.packages.${pkgs.system}.default
      
      # === TERMINALS ===
      ghostty
      alacritty
      
      # === SHELL ===
      zsh
      zsh-autosuggestions
      zsh-syntax-highlighting
      oh-my-zsh
      starship
      
      # === CORE CLI UTILITIES ===
      bat
      eza
      ripgrep
      fd
      fzf
      jq
      yq-go
      bottom
      fastfetch
      zoxide
      procs
      duf
      dust
      sd
      ripgrep-all

      # === VERSION CONTROL ===
      gh
      lazygit
      delta
      
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
      zls
      
      # Rust
      rustc
      cargo
      rust-analyzer
      
      # Node.js
      nodejs_22
      nodePackages.prettier
      nodePackages.typescript-language-server
      
      # === EDITOR & LSPs ===
      neovim
      lua-language-server
      nil
      yaml-language-server
      vscode-langservers-extracted
      marksman
      terraform-ls
      
      # === MONITORING & DEBUGGING ===
      htop
      iotop
      nethogs
      nmap
      tcpdump
      wireshark
      
      # === FILE MANAGEMENT ===
      yazi
      ranger
      unzip
      zip
      
      # === BROWSERS ===
      firefox
      chromium
      google-chrome
      brave

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
      yubikey-manager
      yubikey-personalization
      gnupg
      ollama
    ];

  };

  home-manager.users.bine =
    import ../../home/bine/${config.networking.hostName}.nix;
}
