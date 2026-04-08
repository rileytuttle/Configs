{ config, pkgs, lib, ... }: 

{ 
    home.username = "rileytuttle"; 
    home.homeDirectory = "/home/rileytuttle"; 
    home.stateVersion = "25.11"; 
 
    home.packages = with pkgs; [ 
        git 
        fzf
        tmux 
        firefox
        signal-desktop
        spotify
        xclip
        qrencode
        openscad
        prusa-slicer
        deskflow
        xournalpp
        ripgrep
    ]; 
    home.file.".config/kak/kakrc".source = /home/rileytuttle/Configs/dotfiles/kakrc/kakrc;
    home.file.".tmux.conf".source = /home/rileytuttle/Configs/dotfiles/.tmux.conf;

    programs.bash = {
      enable = true;

      # shell aliases
      shellAliases = {
        ll = "ls -la";
        la = "ls -A";
        l = "ls -CF";
        gs = "git status";
        gd = "git diff";
        gc = "git commit";
        gp = "git push";
        gl = "git log --oneline";
      };

      # runs in every interactive shell (equivalent of .bashrc additions)
      initExtra = ''
        # better history
        HISTSIZE=10000
        HISTFILESIZE=20000
        HISTCONTROL=ignoreboth   # ignore duplicates and lines starting with space
        shopt -s histappend      # append rather than overwrite history

        # auto-correct minor cd typos
        shopt -s cdspell

        # a nice prompt - shows user@host:dir and git branch
        parse_git_branch() {
          git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
        }
        export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[33m\]$(parse_git_branch)\[\033[00m\]\$ '

        # fzf keybindings if you have it installed
        [ -f ~/.fzf.bash ] && source ~/.fzf.bash
        eval "$(${pkgs.fzf}/bin/fzf --bash)"
        # bind up arrow to search history by partial command
        bind '"\e[A": history-search-backward'
        # bind down arrow to search history by partial command
        bind '"\e[B": history-search-forward'

        [ -f ~/Configs/bash-scripts/git-scripts.sh ] && source ~/Configs/bash-scripts/git-scripts.sh
        [ -f ~/Configs/bash-scripts/auto-completes.sh ] && source ~/Configs/bash-scripts/auto-completes.sh ]
        alias gst="git status"

        # makes it so tab complete doesnt care about case 
        bind "set completion-ignore-case on"
        # makes it so the - and _ is same in tab completion
        bind "set completion-map-case on"
        # makes it so only single tab press will bring up completion options
        bind "set show-all-if-ambiguous on"
      '';

      # runs only in login shells (equivalent of .bash_profile)
      profileExtra = ''
        export EDITOR="kak";
        export VISUAL="kak";
      '';
    };

    home.sessionPath = [
      "$HOME/Configs/scripts"
    ];

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "spotify"
    ];

    programs.fzf = {
      enable = true;
      defaultOptions = [ "--layout=reverse" ];
    };
}
