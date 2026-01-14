{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./fzf.nix
    ./bat.nix
    ./eza.nix
    ./zoxide.nix
    ./neofetch.nix
    ./starship.nix
    ./ai.nix
  ];

  home.packages = with pkgs; [
    # Core utilities
    coreutils
    findutils
    diffutils
    
    # File management
    zip
    unzip
    gzip
    bzip2
    tree
    
    # Search tools
    ripgrep
    fd
    
    # System monitoring
    htop
    procs
    
    # Network tools
    httpie
    curl
    wget
    
    # Development essentials
    jq
    
    # Documentation
    tldr
  ];
}
