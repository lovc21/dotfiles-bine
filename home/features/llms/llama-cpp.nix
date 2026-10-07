{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.llms.llama-cpp;
in
{
  options.features.llms.llama-cpp = {
    enable = lib.mkEnableOption "llama.cpp OpenAI-compatible server (llama-server)";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.llama-cpp-vulkan;
      description = "llama.cpp package to use (e.g. llama-cpp, llama-cpp-vulkan, llama-cpp-rocm).";
    };
    hfRepo = lib.mkOption {
      type = lib.types.str;
      description = "Hugging Face repo to load the GGUF from (downloaded on first start).";
    };
    hfFile = lib.mkOption {
      type = lib.types.str;
      description = "GGUF file inside hfRepo.";
    };
    alias = lib.mkOption {
      type = lib.types.str;
      default = "local";
      description = "Model name exposed through the API.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
    };
    contextSize = lib.mkOption {
      type = lib.types.int;
      default = 32768;
    };
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start the server at login. When false, use llm-on / llm-off.";
    };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments passed to llama-server.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.llama-server = {
      Unit = {
        Description = "llama.cpp server (${cfg.alias})";
        After = [ "network-online.target" ];
      };
      Service = {
        ExecStart = lib.escapeShellArgs (
          [
            "${cfg.package}/bin/llama-server"
            "--host"
            "127.0.0.1"
            "--port"
            (toString cfg.port)
            "--hf-repo"
            cfg.hfRepo
            "--hf-file"
            cfg.hfFile
            "--alias"
            cfg.alias
            "--ctx-size"
            (toString cfg.contextSize)
            "--cors-origins"
            "localhost"
          ]
          ++ cfg.extraArgs
        );
        Restart = "on-failure";
        RestartSec = 10;
      };
      Install.WantedBy = lib.mkIf cfg.autoStart [ "default.target" ];
    };

    programs.zsh.shellAliases = {
      llm-on = "systemctl --user start llama-server && journalctl --user -u llama-server -f -n 0";
      llm-off = "systemctl --user stop llama-server";
      llm-status = "systemctl --user status llama-server";
    };
  };
}
