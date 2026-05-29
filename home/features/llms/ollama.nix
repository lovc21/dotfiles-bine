{ config, lib, pkgs, ... }:

let
  cfg = config.features.llms.ollama;
in {
  options.features.llms.ollama = {
    enable = lib.mkEnableOption "Ollama local LLM runner";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama-vulkan;
      description = "Ollama package to use (e.g. ollama, ollama-vulkan, ollama-rocm).";
    };
    models = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Models pulled automatically after the ollama service starts.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = cfg.package;
    };

    systemd.user.services.ollama-pull-models = lib.mkIf (cfg.models != []) {
      Unit = {
        Description = "Pull configured Ollama models";
        After = [ "ollama.service" ];
        Requires = [ "ollama.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "ollama-pull-models" ''
          set -eu
          for model in ${lib.escapeShellArgs cfg.models}; do
            ${cfg.package}/bin/ollama pull "$model"
          done
        '';
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
