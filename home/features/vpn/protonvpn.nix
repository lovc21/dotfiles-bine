{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.vpn.protonvpn;
in {
  options.features.vpn.protonvpn = {
    enable = mkEnableOption "ProtonVPN";
    useGui = mkOption {
      type = types.bool;
      default = false;
      description = "Install GUI application instead of CLI";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (if cfg.useGui then protonvpn-gui else protonvpn-cli)
    ];
  };
}
