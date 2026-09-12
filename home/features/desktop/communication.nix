{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.desktop.communication;
in
{
  options.features.desktop.communication.enable = lib.mkEnableOption "chat / communication apps";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (slack.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeWrapper ];
        postFixup = (old.postFixup or "") + ''
          wrapProgram $out/bin/slack --add-flags "--disable-gpu"
        '';
      }))
      (discord.override { commandLineArgs = "--disable-gpu"; })
    ];
  };
}
