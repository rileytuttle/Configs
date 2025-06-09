# setting up my bash environment
#
# WORK IN PROGRESS

if [ ! -d "$HOME/.oh-my-bash" ]; then
    echo "installing oh my bash"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
    exit 0
fi

echo 'if [ -f ~/Configs/bash-scripts/git-script.sh ]; then' >> ~/.bashrc
echo '    source ~/Configs/bash-scripts/git-scripts.sh' >> ~/.bashrc
echo 'fi' >> ~/.bashrc

if ! command -v rg >/dev/null; then
    sudo apt install ripgrep
fi

if ! command -v fzf >/dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    echo 'export FZF_DEFAULT_OPTS="--layout=reverse"' >> ~/.bashrc
fi
