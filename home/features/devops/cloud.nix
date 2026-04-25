{ config, lib, pkgs, ... }:

let
  cfg = config.features.devops.cloud;
in {
  options.features.devops.cloud.enable = lib.mkEnableOption "cloud SDKs";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (google-cloud-sdk.withExtraComponents (
        with google-cloud-sdk.components; [
          gke-gcloud-auth-plugin
        ]
      ))
      awscli2
    ];
  };
}
