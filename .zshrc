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


export EDITOR=kak
export ZSHRC="/home/rtuttle/.zshrc"
export VIMRC="/home/rtuttle/.vimrc"
export KAKRC="/home/rtuttle/.config/kak/kakrc"
export PYTHONPATH="$PYTHONPATH:$BREWST_HOME/result/debug-common/python"
export PATH="/usr/bin:$PATH"
export PATH="$HOME/scripts:$HOME/scripts/keylogging:$PATH"
export PATH="/opt/irobot/brewst-1.0/bin:/opt/irobot/x86_64-oesdk-linux/usr/bin/arm-oe-linux-gnueabi:$PATH"
export PATH="$HOME/kakoune/src:$PATH"
export PATH="$HOME/Logic_Saleae_64_bit_1-2-18:$PATH"
function zshrc() {
    if [ $# -eq 0 ]; then
        vim ~/.zshrc
    fi
    source ~/.zshrc
    echo "sourced ~/.zshrc"
}
alias zshrc='$EDITOR $ZSHRC; source $ZSHRC; echo "sourced $ZSHRC"'
alias vimrc='$EDITOR $VIMRC;'
alias kakrc='$EDITOR $KAKRC;'
#git aliases
unalias gpo  2>/dev/null
unalias gpod 2>/dev/null
unalias gst 2>/dev/null
unalias gd 2>/dev/null
unalias gbd 2>/dev/null
unalias gbD 2>/dev/null
unalias gp 2>/dev/null
unalias grbi 2>/dev/null
unalias gco 2>/dev/null
unalias gcp 2>/dev/null

alias gp="git pull"
function get_branch() {
	git branch | fzf --ansi -1 $@ | sed "s/^* //"
}
unalias grb
alias grb='git rebase $(get_branch)' 
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
    commit_hash=$(git log --pretty=format:"%H" | fzf --ansi --preview 'git show --pretty=short --abbrev-commit --name-only {}')
    if [ ! -z $commit_hash ]; then
        git rebase -i $commit_hash
    fi
}

function gco() {
	cmd=""
	if [ $# -eq 0 ]; then
		branch_name=$(get_branch --no-multi)
		if [ ! -z $branch_name ]; then
			cmd="git checkout $branch_name"
		fi
	else
		if [ $1 = "--file" ]; then
			branch_name=$(get_branch --no-multi)
			file_names=$(fzf)
			if [ ! -z $file_names ]; then
				cmd="git checkout $branch_name -- $file_names"
			fi
		else
			cmd="git checkout $@"
		fi
	fi
	if [ ! -z $cmd ]; then
		cmd="$cmd; git submodule update; git got get"
	fi
	eval $cmd
}

function gcp() {
	if [ $# -eq 0 ]; then
		git cherry-pick $(git log --pretty=format:"%H" $(git branch | fzf --ansi) | fzf --ansi --preview 'git show --pretty=short --name-only {}')
	else
		git cherry-pick $@
	fi
}

function gd() {
	if [ $# -eq 0 ]; then
		commit_hash=$(git log --pretty=format:"%H" | fzf --ansi --preview 'git show --pretty=short --name-only {}')
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
function gbd() {
	branch_name=$(get_branch)
	if [ ! -z $branch_name ]; then
		git branch --delete $branch_name
	fi
}
function gbD() {
	branch_name=$(get_branch)
	if [ ! -z $branch_name ]; then
		git branch --delete --force $branch_name
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
    cmd="$EDITOR"
    if [ "$EDITOR" -eq "vim" ]; then
        cmd="$cmd -p"
    fi       
    cmd="$cmd $(tr '\n' ' ' <<< $paths_selected)" # open all selected files in vim tabs
    eval $cmd
}

#alias externalip='dig myip.opendns.com +short'
alias externalip='curl --silent ifconfig.me | sed "s/\n//"'
alias brewst="cd ~/brewst"
alias scratch="vim ~/scratch"
alias todo="vim ~/TODO"
function howlong() {
	if [ $# -eq 1 ]; then 
		ps -p $1 -o etime
	else
		echo "expected 1 argument; got $#"
	fi
}

function copylines() {
    #inputfile=$(fzf)
    #inserttext=$(cat $inputfile | fzf)
    #outputfile=$(fzf)
    #insertlocation=$(nl -ba -nln $outputfile | fzf --no-multi --ansi | sed 's/^\([0-9]*\).*/\1/')
    #ex -s -c "${insertlocation}i|$inserttext" -c x $outputfile 
    inputfile=$1
    #outputfile=$2
    startinput=$(sed 's/\([0-9]*\):[0-9]*/\1/') <<< $2
    stopinput=$(sed 's/[0-9]*:\([0-9]*\)/\1/') <<< $2
    if [ -z $stopinput ]; then
        inserttext=$(sed -n "${startinput}p" $inputfile)
    else
        inserttext=$(sed -n "${startinput},${stopinput}p" $inputfile)
    fi
    echo $inserttext
    #ex -s -c "${insertlocation}i|${inserttext}" -c x $outputfile 

}
alias octave='octave --no-gui --quiet'
alias octave-gui='octave'
function keylog() {
    sudo ~/scripts/keylogging/keylogcounter $@
}
