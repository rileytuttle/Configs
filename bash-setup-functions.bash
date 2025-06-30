function install_oh_my_bash()
{
    if [ ! -d "$HOME/.oh-my-bash" ]; then
        echo "installing oh my bash"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
        exit 0
    fi
}

function add_source_git_scripts()
{
    echo 'if [ -f ~/Configs/bash-scripts/git-script.sh ]; then' >> ~/.bashrc
    echo '    source ~/Configs/bash-scripts/git-scripts.sh' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
}

function install_ripgrep()
{
    if ! command -v rg >/dev/null; then
        sudo apt install ripgrep
    fi
}

function install_fzf()
{
    if ! command -v fzf >/dev/null; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
        echo 'export FZF_DEFAULT_OPTS="--layout=reverse"' >> ~/.bashrc
    fi
}

function install_apt_kak_light()
{
    if ! command -v kak >/dev/null; then
        sudo apt update && sudo apt install kakoune
        mkdir -p ~/.config/kak/plugins
        ln -s ~/Configs/kakrc_light/kakrc ~/.config/kak/kakrc
    fi
}

function install_kak_from_source()
{
    if ! command -v kak >/dev/null; then
        git clone https://github.com/rileytuttle/kakoune.git ~/kakoune
        cd kakoune
        sudo apt install build-essential make
        make
        echo 'export PATH=~/kakoune/src:$PATH' >> ~/.bashrc
        mkdir -p ~/.config/kak/plugins
        ln -s ~/Configs/kakrc/kakrc ~/.config/kak/kakrc
    fi
}

function install_tmux()
{
    if ! command -v tmux >/dev/null; then
        sudo apt update && sudo apt install tmux
        ln -s ~/Configs/.tmux.conf ~/.tmux.conf
    fi
}

function fix_ctrl_alt_down_shortcut()
{
    echo "to see what keybindings there are use:"
    echo ">> gsettings list-recursively org.gnome.desktop.wm.keybindings"
    echo "to clear shortcut use:"
    echo ">> gsettings set org.gnome.desktop.wm.keybindings <shortcut_name> []"
    shortcut_name=$(gsettings list-recursively org.gnome.desktop.wm.keybindings | grep "\['<Control><Alt>Down'\]" | cut -d ' ' -f2)
    gsettings set org.gnome.desktop.wm.keybindings $shortcut_name []
}

function setup_git_ssh_key()
{
    echo "setting up ssh key for git"
    ssh-keygen -t ed25519 -C "rileytuttle@gmail.com"
    eval "$(ssh-agent -s)"
    if [ -f ~/.ssh/id_ed25519 ]; then
        ssh-add ~/.ssh/id_ed25519
    else
        echo "add key to ssh agent with:"
        echo ">> ssh-add /path/to/key/id_ed25519"
    fi
}

function setup_flatpak()
{
    if ! command -v flatpak >/dev/null; then
        sudo apt install flatpak
        sudo apt install gnome-software-plugin-flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        echo "needs restart before paths are set up correctly"
    fi
}
