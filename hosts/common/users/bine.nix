{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.bine = {
    isNormalUser = true;
    description = "jakob";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = [
      inputs.home-manager.packages.${pkgs.system}.default
    ];
  };
  
  # This imports home/bine/${hostname}.nix
  # Since your hostname is "bine", it imports home/bine/bine.nix
  home-manager.users.bine =
    import ../../../home/bine/${config.networking.hostName}.nix;
}
