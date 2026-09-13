{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.torrent-client.transmission;
in
{
  options.features.torrent-client.transmission.enable =
    lib.mkEnableOption "Transmission BitTorrent client (GTK GUI)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      transmission_4-gtk
    ];
  };
}
