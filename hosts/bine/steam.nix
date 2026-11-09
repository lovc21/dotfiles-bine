{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.steam;
in
{
  options.features.steam.openLanPorts = lib.mkEnableOption "Steam Remote Play, local game transfers and dedicated server ports";

  config = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = cfg.openLanPorts;
      localNetworkGameTransfers.openFirewall = cfg.openLanPorts;
      dedicatedServer.openFirewall = cfg.openLanPorts;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
      protonup-qt
    ];
  };
}
