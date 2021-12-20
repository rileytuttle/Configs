# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ripgrep)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# for now both kak but not sure if kak works from ssh session
if [[ -n $SSH_CONNECTION ]]; then
  # export EDITOR='vim'
  export EDITOR='kak'
else
  # export EDITOR='mvim'
  export EDITOR='kak'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

unameOut="$(uname -s)"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# to change git editor change .gitconfig
newgitconfig=$(sed "s/editor = .*/editor = $EDITOR/" < $HOME/.gitconfig) # changes git editor to match my $EDITOR
echo $newgitconfig > $HOME/.gitconfig
export CONFIG_REPO_HOME="$HOME/Configs"
export ZSHRC="$CONFIG_REPO_HOME/.zshrc"
export KAKRC="$HOME/.config/kak/kakrc"
export TMUXCONF="$HOME/.tmux.conf"
export PYTHONPATH="$PYTHONPATH:${HOME}/GTOMSCS/CS7646/"
export PYTHONPATH="$PYTHONPATH:${BREWST_HOME}/slam-tools/python/gui"
export PYTHONPATH="$PYTHONPATH:${HOME}/Configs/scripts"
export PATH="/usr/bin:$PATH"
export PATH="$HOME/kakoune/src:$PATH"
export PATH="$HOME/scripts:$HOME/scripts/keylogging:$PATH"
export PATH="$HOME/.kakoune/src:$PATH"
export PATH="$HOME/Configs/scripts:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/duc-1.4.4:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# export PATH="$HOME/miniconda3/bin:$PATH"  # commented out by conda initialize
export FLATCAM_PATH="$HOME/flatcam/FlatCAM.py"
alias flatcam="python $FLATCAM_PATH"

alias find="fd"
export FZF_DEFAULT_COMMAND='fd -I --type f --type d --color=never'
export FZF_HEIGHT="30"
export FZF_DEFAULT_OPTS="--layout=reverse --height=$FZF_HEIGHT --multi --extended"
#export FZF_ALT_C_COMMAND='fd --type d . g-color=never'

alias kakrc='$EDITOR $KAKRC'
alias tmuxconf='$EDITOR $TMUXCONF'
alias vimrc='$EDITOR $VIMRC'
alias zshrc='$EDITOR $ZSHRC; source $ZSHRC; echo "sourced $ZSHRC"'

alias xclip='xclip -selection clipboard'

#git aliases
unalias ga    2>/dev/null
unalias gb    2>/dev/null
unalias gbd   2>/dev/null
unalias gbD   2>/dev/null
unalias gcam  2>/dev/null
unalias gco   2>/dev/null
unalias gcp   2>/dev/null
unalias gd    2>/dev/null
unalias glog  2>/dev/null
unalias gp    2>/dev/null
unalias gpo   2>/dev/null
unalias gpod  2>/dev/null
unalias gr    2>/dev/null
unalias grb   2>/dev/null
unalias grbi  2>/dev/null
unalias gst   2>/dev/null
unalias gstnu 2>/dev/null
unalias gsu   2>/dev/null

function get_branch() {
    git branch | fzf-tmux --ansi -1 $@ | sed 's/^[*+]\?\s*//'
}
function ga() {
    if [ $# -eq 0 ]; then
        files_to_stage=$(git status --porcelain | fzf-tmux | sed 's/ M //')
        if [ ! -z $files_to_stage ]; then
            git add $files_to_stage
        fi
    else
        git add $@
    fi
}
function gb() {
    if [ $# -eq 0 ]; then
        get_branch
    else
        git branch $@
    fi
        
}
function gbd() {
    branch_name=$(get_branch)
    if [ ! -z $branch_name ]; then
        git branch --delete $branch_name
    fi
}
function gbD() {
    branch_names=$(get_branch)
    # if [ ! -z $branch_name ]; then
    #     git branch --delete --force $branch_name
    # fi
    setopt sh_word_split
    for branch in $branch_names
    do
        git branch --delete --force $branch
    done
    unsetopt sh_word_split
}
function gcam() {
    git commit -a -m "$@"
}
function gco() {
    cmd=""
    no_update=0
    if [ $# -eq 0 ]; then
        branch_name=$(get_branch --no-multi)
        if [ ! -z $branch_name ]; then
            cmd="git checkout $branch_name"
        fi
    else
        if [ $1 = "--file" ]; then
            branch_name=$(get_branch --no-multi)
            file_names=$(fzf-tmux)
            if [ ! -z $file_names ]; then
                cmd="git checkout $branch_name -- $file_names"
            fi
        elif [ $1 = "--no-update" ]; then
            no_update=1
            branch_name=$(get_branch --no-multi)
            if [ ! -z $branch_name ]; then
                cmd="git checkout $branch_name"
            fi
        else
            cmd="git checkout $@"
        fi
    fi
    if [ ! -z $cmd ]; then
        if [ $no_update -eq 1 ]; then
            cmd="$cmd"
        else
            cmd="$cmd && (git submodule update --init --recursive)"
        fi
    fi
    eval $cmd
}
# can cherry pick single commit or any contiguous commits
# cannot cherry pick two separate chunks of commits
# Example hashes:
#   hash 10000
#   hash 20000
#   hash 30000
#   hash 40000
#   hash 50000
# can take hash 10000
# can take hash 10000, 20000, 3000
# cannot take hash 10000, 20000, 40000, 50000
function gcp() {
    if [ $# -eq 0 ]; then
        branch_name=$(get_branch --no-multi)
        commit_list=$(git log --pretty=format:"%H" $branch_name | fzf-tmux --ansi --preview 'git show --pretty=short --name-only {}')
        commit_number=$(echo $commit_list | wc -l)
        if [ $commit_number -eq 1 ]; then
            git cherry-pick $commit_list
        elif [ $commit_number -gt 1 ]; then
            first_commit=$(echo $commit_list | tail -n1)
            last_commit=$(echo $commit_list | head -n1)
            git cherry-pick ${first_commit}^..${last_commit}
        fi
            
        # git cherry-pick $(git log --pretty=format:"%H" $(git branch | fzf-tmux --ansi) | fzf-tmux --ansi --preview 'git show --pretty=short --name-only {}')
    else
        git cherry-pick $@
    fi
}
function glog() {
    branch_name=$(get_branch --no-multi)
    git log $@ $branch_name
}
function gd() {
    if [ $# -eq 0 ]; then
        commit_hash=$(git log --pretty=format:"%H" | fzf-tmux --ansi --preview 'git show --pretty=short --name-only {}')
        #commit_hash=${commit_hash//$'\n'/ } # example of bash variable expansion, will replace newlines with spaces
        # note: the above is not needed when using the sh_word_split and the for loop but I am leaving it for example of bash variable expansion
        unset commit_hash_rev
        setopt sh_word_split
        for hash in $commit_hash
        do
            commit_hash_rev="$hash $commit_hash_rev"
        done
        unsetopt sh_word_split
        if [ ! -z $commit_hash_rev ]; then
            cmd="git diff $commit_hash_rev"
            eval $cmd
        fi
    else
        git diff $@
    fi
}
alias gp="git pull"
function gpo() {
    branch_name=$(get_branch)
    if [ ! -z $branch_name ]; then
        git push origin $branch_name
    fi
}
function gpod() {
    branch_name=$(get_branch)
    if [ ! -z $branch_name ]; then
        git push --delete origin $branch_name
    fi
}
function grb () {
    if [ $# -eq 0 ]; then
        branch_name=$(get_branch)
        if [ ! -z $branch_name ]; then
            git rebase $branch_name
        fi
    else
        git rebase $@
    fi
}
function grbi() {
    commit_hash=$(git log --pretty=format:"%H" | fzf-tmux --ansi --preview 'git show --pretty=short --abbrev-commit --name-only {}')
    if [ ! -z $commit_hash ]; then
        git rebase -i $commit_hash
    fi
}
function gr() {
    if [ $# -eq 0 ]; then
        commit_list=$(git log --pretty=format:"%H" | fzf-tmux --ansi --preview 'git show --pretty=short --name-only {}')
        commit_number=$(echo $commit_list | wc -l)
        setopt sh_word_split
        for commit_hash in $commit_list
        do
            git revert $commit_hash
        done
        unsetopt sh_word_split
    else
        git revert $@
    fi
}
alias gsu="git submodule update --init --recursive"
alias gst="git status"
alias gstnu="git status --untracked=no"
    
#spotify aliases
alias play="spotifycli --playpause"
alias next="spotifycli --next"
alias prev="spotifycli --prev"
function songinfo() {
    song=$(spotifycli --song);
    album=$(spotifycli --album);
    artist=$(spotifycli --artist);
    { echo "SONG|-  ALBUM|-  ARTIST";
      echo "$song|-  $album|-  $artist"; } | 
    column -t -s'|';
}
#other aliases
alias grep="rg -n --color=always --hidden --smart-case"

function cat() {
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    if [ "$extension" = "md" ] && [ "$(command -v mdcat)" ]; then
        mdcat $1
    elif [ "$(command -v bat)" ]; then
        bat $1
    else
        cat $1
    fi
}

alias lock="gnome-screensaver-command -l"
alias less="less -NRM"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | less"

function temp() {
    temps=$(cat /sys/class/thermal/thermal_zone*/temp);
    setopt sh_word_split
    for t in $temps
     do
        echo "scale=2; $t * 9 / 5000 + 32" | bc
    done
    unsetopt sh_word_split
}

alias bc="bc -ql"

alias nosleepon="sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias nosleepoff="sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"

if [ -f ~/.fzf.zsh ]; then 
    source ~/.fzf.zsh
fi

function rgo() {
    # get selections by piping ripgrep through fuzzy search
    total_match=$(rg -n --color always --hidden --smart-case $@ | fzf-tmux --ansi -1 --preview 'preview.sh {}' | sed 's/\([^:]*\):\([0-9]*\):.*/\1 +\2;/' | tr -d '\n')
    # loop through filename:linenumber and open in editor 
    setopt sh_word_split
    IFS=';'
    for line in $total_match; do
        pathname=$(cut -d' ' -f1 <<< $line)
        linenum=$(cut -d' ' -f2 <<< $line)
        if [ ! -z $pathname ]; then
            eval "$EDITOR $pathname $linenum"
            #eval 'tmux split-window "$EDITOR $pathname $linenum"'
        fi
    done
    unsetopt sh_word_split
    unset IFS
}

function fopen() {
    # get selections by piping through fuzzy search
    args="$@"
    echo "$args"
    if [ $# -eq 0 ]; then
        paths_selected=$(fzf-tmux)
    else
        paths_selected=$(fzf-tmux -1 -0 --query="$args")
        echo $paths_selected
        if [ -z $paths_selected ]; then
            rgo "$args"
            return 1
        fi
    fi
    if [ ! -z $paths_selected ]; then
        cmd="$EDITOR"
        if [ "$EDITOR" = "vim" ]; then
            cmd="$cmd -p"
        fi
        cmd="$cmd $(tr '\n' ' ' <<< $paths_selected)" # open all selected files in vim tabs
        eval $cmd
        #echo ": $(date +%s):0:$cmd" >> ~/.zsh_history
    else
        echo "nothing to open"
    fi
}

alias externalip='curl --silent ifconfig.me | sed "s/\n//"'
alias tmxu="tmux"
alias tmx="tmux"
alias scratch="$EDITOR ~/scratch"
alias todo="$EDITOR ~/TODO"
alias dls="cd ~/Downloads; ls -alh"

function howlong() {
    if [ $# -eq 1 ]; then 
        ps -p $1 -o etime
    else
        echo "expected 1 argument; got $#"
    fi
}

alias octave='octave --no-gui --quiet'
alias octave-gui='octave'

function keylog() {
    sudo ~/scripts/keylogging/keylogcounter $@
}

alias sl="ls"
alias pk="~/qmk_firmware/print_keymaps"

function beep() {
    if [[ $unameOut == "Linux" ]]; then
        paplay /usr/share/sounds/ubuntu/notifications/Blip.ogg
    else
        exit
    fi
}

function notify() {
    if [[ $unameOut == "Linux" ]]; then
        if [[ -z $@ ]]; then
            msg="DONE"
        else
            msg="$@"
        fi
        notify-send "$msg"
    else
        exit
    fi
}

function nb() { #nb is short for notify && beeep
    last_exit_status="$?"
    if [ -z $@ ]; then
        lastCommand=$(cat $HOME/.zsh_history |tail -n1 | sed 's/: [0-9]*:[0-9]*;//' | sed 's/; nb//')
        if [[ $last_exit_status -eq 0 ]]; then
            notify "\"$lastCommand\" succeeded" && beep
        else
            notify "\"$lastCommand\" failed" && beep
        fi
    else
        notify $@ && beep
    fi
}

function ping_till_alive() {
    while [ true ]; do
        ping -c1 $1 && nb "$1 alive" && break;
        sleep 1;
    done;
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
alias flatcam="python $HOME/flatcam/FlatCAM.py"
if [ $(command -v conda) ]; then
    __conda_setup="$('/home/rtuttle/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/rtuttle/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/home/rtuttle/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/rtuttle/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
    # conda deactivate
# else
#     echo "conda not available"
fi

if [ ! -z $IN_KAKOUNE_CONNECT ]; then
    PS1="kak >> "
fi

alias skak="sudo $(which kak)"
alias python="python3"
alias calc='python -i -c "from math import *;\
                          import numpy as np;\
                          print(\"python calculator\")\
                          "'

export PATH=$PATH:$HOME/electric_eel_barrow/bin
alias acli='arduino-cli'

if [ -f ~/configs_and_scripts/.setup_irobot_specific.bash ]; then
    source $HOME/configs_and_scripts/.setup_irobot_specific.bash
fi

# added by auto-cone setup script
# do not touch
if [ -f ~/auto-cone/.setup_auto_cone_specific.bash ]; then
    source $HOME/auto-cone/.setup_auto_cone_specific.bash
fi

# direnv instructions
# have an .envrc file in the folders where we
# want to overwrite any environment variables
# then inside just export them as usual
# export MY_ENV=whatever
# direnv will keep track of loading them when we switch
# in and out of that folder
if [ ! command -v direnv &> /dev/null ]; then
    echo "direnv not installed. be careful with git worktree stuff"
else
    eval "$(direnv hook zsh)"
fi

# instructions for linking this repoed zshrc file to the one used in $HOME/.zshrc
# ln -s ~/Configs/.zshrc ~/.zshrc
# that will create a symbolic link at ~/.zshrc pointing to Configs/.zshrc
# that way I can host the Configs/.zshrc somewhere else
