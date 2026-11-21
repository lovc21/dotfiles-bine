{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  users.users.bine = {
    isNormalUser = true;
    description = "jakob";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.zsh;
    packages = [
      inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  # This imports home/bine/${hostname}.nix
  # Since your hostname is "bine", it imports home/bine/bine.nix
  home-manager.users.bine = import ../../../home/bine/${config.networking.hostName}.nix;

  programs.zsh.promptInit =
    let
      rootSettings = builtins.fromJSON (
        builtins.replaceStrings
          [
            " ](bg:#a3aed2 fg:#090c0c)"
            "#a3aed2"
            "#769ff0"
            "[❯](bold green)"
            "[❯](bold red)"
            "[❮](bold green)"
          ]
          [
            " root ](bg:#f7768e fg:#090c0c)"
            "#f7768e"
            "#db4b4b"
            "[#](bold red)"
            "[#](bold yellow)"
            "[❮](bold red)"
          ]
          (builtins.toJSON config.home-manager.users.bine.programs.starship.settings)
      );
    in
    ''
      if (( EUID == 0 )) && [[ $TERM != "dumb" ]]; then
        export STARSHIP_CONFIG=${(pkgs.formats.toml { }).generate "starship-root.toml" rootSettings}
        eval "$(${lib.getExe pkgs.starship} init zsh)"
      else
        autoload -U promptinit && promptinit && prompt suse && setopt prompt_sp
      fi
    '';
}
