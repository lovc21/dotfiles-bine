{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./hyprland.nix
    ./wayland.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
  ];
}

