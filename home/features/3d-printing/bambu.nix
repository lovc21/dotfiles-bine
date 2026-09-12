{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features."3d-printing".bambu;
in
{
  options.features."3d-printing".bambu.enable = lib.mkEnableOption "Bambu Studio 3D printer slicer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.stable.bambu-studio
    ];
  };
}
