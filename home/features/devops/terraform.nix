{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.devops.terraform;
in
{
  options.features.devops.terraform.enable = lib.mkEnableOption "terraform tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      terraform
      terraform-ls
      tflint
    ];

    home.file.".terraformrc".text = ''
      plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
    '';

    # terraform refuses to create the cache dir itself; the .keep file
    # makes home-manager create it
    home.file.".terraform.d/plugin-cache/.keep".text = "";
  };
}
