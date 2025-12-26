{ config, lib, pkgs, ... }:

let
  cfg = config.features.cli.starship;
in
{
  options.features.cli.starship.enable = lib.mkEnableOption "starship prompt";

  config = lib.mkIf cfg.enable {
    # Install Nerd Font for icons
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      
      settings = {
        # Main prompt format with ROUNDED corners
        format = lib.concatStrings [
          "[░▒▓](#a3aed2)"
          "[  ](bg:#a3aed2 fg:#090c0c)"
          "[](bg:#769ff0 fg:#a3aed2)"
          "$directory"
          "[](fg:#769ff0 bg:#394260)"
          "$git_branch"
          "$git_status"
          "[](fg:#394260 bg:#212736)"
          "$nodejs"
          "$rust"
          "$golang"
          "$python"
          "$nix_shell"
          "$terraform"
          "$kubernetes"
          "[](fg:#212736 bg:#1d2230)"
          "$cmd_duration"
          "[](fg:#1d2230)"
          " "
          "\n$character"
        ];
        
        # Time on the right side
        right_format = "$time";
        
        directory = {
          style = "fg:#e3e5e5 bg:#769ff0";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
          };
        };
        
        git_branch = {
          symbol = "";
          style = "bg:#394260";
          format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
        };
        
        git_status = {
          style = "bg:#394260";
          format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
        };
        
        nodejs = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };
        
        rust = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };
        
        golang = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };
        
        python = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };
        
        nix_shell = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ](fg:#769ff0 bg:#212736)]($style)";
        };
        
        terraform = {
          symbol = "󱁢";
          style = "bg:#212736";
          format = "[[ $symbol ($workspace) ](fg:#769ff0 bg:#212736)]($style)";
        };
        
        kubernetes = {
          symbol = "☸";
          style = "bg:#212736";
          format = "[[ $symbol ($context) ](fg:#769ff0 bg:#212736)]($style)";
          disabled = false;
        };
        
        cmd_duration = {
          min_time = 3000;
          style = "bg:#1d2230";
          format = "[[ 󰔛 $duration ](fg:#a0a9cb bg:#1d2230)]($style)";
        };
        
        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:#1d2230";
          format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
        };
        
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vicmd_symbol = "[❮](bold green)";
        };
      };
    };
  };
}
