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
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


export EDITOR=vim
export VIMRC="~/.vimrc"
export PYTHONPATH="$PYTHONPATH:$BREWST_HOME/result/debug-common/python"
export PATH="$PATH:/usr/bin"
alias zshrc='vim ~/.zshrc; source ~/.zshrc; echo "sourced ~/.zshrc"'
alias vimrc="vim $VIMRC"

#git aliases
# remove existing aliases from .oh-my-zsh/plugins/git/git.plugins.zsh
alias gp="git pull"
function grbi() {
	commit_hash=$(git log --pretty=format:"%H" | fzf --ansi --preview 'git show --pretty=oneline --abbrev-commit --name-only {}')
	if [ ! -z $commit_hash ]; then
		git rebase -i $commit_hash
	fi
}

function gco() {
	if [ $# -eq 0 ]; then
		git checkout $(git branch | fzf --ansi -1) 
	else
		git checkout $@
	fi
}

function gcp() {
	if [ $# -eq 0 ]; then
		git cherry-pick $(git log --pretty=format:"%H" $(git branch | fzf --ansi) | fzf --ansi --preview 'git show --oneline --name-only {}')
	else
		git cherry-pick $@
	fi
}

alias gpo='git push origin $(git branch | fzf --ansi -1 | sed "s/^* //")'
alias gpod='git push --delete origin $(git branch | fzf --ansi -1 | sed "s/^* //")'
alias gst='git status --untracked-files=no'
function gd() {
	if [ $# -eq 0 ]; then
		commit_hash=$(git log --pretty=format:"%H" | fzf --ansi --preview 'git show --oneline --name-only {}')
		if [ ! -z $commit_hash ]; then
			git diff $commit_hash
		fi
	else
		git diff $@
	fi
}
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
alias cat="bat"
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
#window management aliases
# function moveterm() {
# 	xdotool key alt+F7;
# 	xdotool keydown --delay 2000 $1;
# 	xdotool keyup --delay 12 $1;
# 	xdotool key Return;
# }
#alias roboscope="nohup robo-scope &"
function roboscope() { 
	if [ $# -lt 1 ]; then
		nohup robo-scope >/dev/null 2>&1 &;
	else
		nohup robo-scope -connect edison-$1:9999 -mobConnect edison-$1:1234 ${@:2} >/dev/null 2>&1 &;
	fi
}
alias find="fd"
alias nosleepon="sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias nosleepoff="sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"
export FZF_DEFAULT_COMMAND='fd --type f --type d --color=never'
export FZF_HEIGHT="30"
export FZF_DEFAULT_OPTS="--layout=reverse --height=$FZF_HEIGHT --multi --extended"
#export FZF_ALT_C_COMMAND='fd --type d . g-color=never'
export PATH="$PATH:$HOME/skim/bin"
if [ -f ~/.fzf.zsh ]; then 
	source ~/.fzf.zsh
fi

function rgo() {
	# get selections by piping ripgrep through fuzzy search
	total_match=$(rg -n --color always --hidden --smart-case $@ | fzf --ansi -1 --preview 'preview.sh {}' | sed 's/\([^:]*\):\([0-9]*\):.*/\1 +\2;/' | tr -d '\n')
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
	if [ $# -eq 0 ]; then
		paths_selected=$(fzf)
	elif [ $# -eq 1 ]; then
		paths_selected=$(fzf -1 --query=$1)
	else
		echo "too many arguments"
		exit 1
	fi
	# loop through selections and open with editor
	setopt sh_word_split
	for path_name in $paths_selected; do
		if [ ! -z $path_name ]; then
			eval "$EDITOR $path_name"
		fi
	done
	unsetopt sh_word_split
}

