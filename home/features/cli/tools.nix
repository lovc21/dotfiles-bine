{ config, lib, pkgs, ... }:

let
  cfg = config.features.cli.tools;
in {
  options.features.cli.tools.enable = lib.mkEnableOption "general CLI utilities";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      yq-go
      bottom
      duf
      dust
      sd
      ripgrep-all
      iotop
      nethogs
      nmap
      tcpdump
      wireshark
      dig
      tokei
      hyperfine
      glow
      slides
      just
      rsync
      rclone
      yazi
      ranger
      mpv
      radeontop
      cloc
      gping
      whois
      bitwise
    ];
  };
}
