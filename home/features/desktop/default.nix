{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./hyprland.nix
    ./wayland.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./stylix-overrides.nix
  ];

  home.packages = with pkgs; [
  ];
}

