{ config, lib, pkgs, ... }:

{
  # Bash with sensible aliases + history defaults.
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 50000;
    historyFileSize = 100000;

    shellAliases = {
      # eza > ls
      ls   = "eza --group-directories-first";
      ll   = "eza -l --group-directories-first --git";
      la   = "eza -la --group-directories-first --git";
      tree = "eza --tree";

      # bat > cat
      cat = "bat --paging=never";

      # Quality of life
      g  = "git";
      gs = "git status";
      gd = "git diff";

      # NixOS shortcuts — run from inside the flake repo.
      rebuild   = "sudo nixos-rebuild switch --flake .#g14";
      rebuilds  = "sudo nixos-rebuild switch --flake .#g14 --show-trace";
      update    = "nix flake update";
      gc        = "sudo nix-collect-garbage -d";
    };

    initExtra = ''
      # fzf history search.
      eval "$(fzf --bash 2>/dev/null || true)"
    '';
  };

  # FZF, direnv, etc. — small dev quality-of-life.
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  # Git — fill in identity. Email is your real address; name is whatever
  # you want commits attributed to.
  programs.git = {
    enable = true;
    userName = "Jake";
    userEmail = "jake.guernon@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };

    aliases = {
      co = "checkout";
      br = "branch";
      st = "status";
      lg = "log --oneline --graph --decorate --all";
    };
  };

  # GitHub CLI.
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
