BASE_PATH=$HOME/shell_setup
DEP_PATH=$BASE_PATH/dependencies
SETTINGS_PATH=$BASE_PATH/settings

function create_symlinks {
    echo "Creating Simlinks"

    DOTFILE_PATH=$BASE_PATH/dotfiles/.*

    ln="ln -sf"

    echo $DOTFILE_PATH

    for file in $DOTFILE_PATH; do
        echo $file

        if [ -f "$file" ]; then
            name=${file##*/}
            symlink=$HOME/$name
            $ln $file $symlink
            echo "Created Symlink of $name at $symlink"
        fi
    done
}

function install_basics {
    if [[ $(uname) == "Darwin" ]]; then
        echo -e "Homebrew:\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew tap Homebrew/bundle
        read -p "Do you wish to install all Homebrewpackages from dependencies/Brewfile? [y/n] " RESP
        if [ "$RESP" = "y" ]; then
            brew_bundle
        fi
    elif [[ $(uname) == "Linux" ]]; then
        echo -e "Pacman:\n"
        sudo pacman -Syyu
        read -p "Do you wish to install all Pacman packages from dependencies/pacman.txt? [y/n] " RESP
        if [ "$RESP" = "y" ]; then
            pacman_bundle
        fi

        echo -e "KDE:\n"
        read -p "Do you wish to install all KDE settings from settings/kde? [y/n] " RESP
        if [ "$RESP" = "y" ]; then
            kde_setup
        fi
    fi

    echo -e "\nNPM Packages"
    npm_bundle

    echo -e "\nPython Dependencies"
    python_bundle

    echo -e "\nPython VENV Dependencies"
    venv_bundle
}

function kde_setup {
    sudo pacman -S latte-dock
    cp -r $SETTINGS_PATH/kde/config/* $HOME/.config
    cp -r $SETTINGS_PATH/kde/local/* $HOME/.local/share
    echo -e "done"
}


function ohmyzsh {
    omz_url=https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    wget $omz_url
    chmod 755 ./install.sh
    ./install.sh --keep-zshrc
}

function ohmyzsh_plugins {
    echo -e "\n installing Plugins"
    OMZ_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
    plugins=$(cat $DEP_PATH/omz_plugins)

    for plugin in $plugins; do
        name=${plugin##*/}
        name=${name%.*}

        echo -e "Installing $name"
        git clone $plugin $OMZ_DIR/$name
    done
}

function brew_bundle {
    cd $DEP_PATH
    brew bundle
}

function pacman_bundle {
    cd $DEP_PATH
    sudo pacman -S --needed - < pacman.txt
}

function npm_bundle {
    xargs npm install --global < $DEP_PATH/node
}

function python_bundle {
    dep_files=$DEP_PATH/python/*

    for file in $dep_files; do
        if [ -f "$file" ]; then
            py=$(basename $file | sed 's/\.[^.]*$//')
            $py -m pip install --requirement $file
        fi
    done
}

function venv_bundle {
    dep_files=$DEP_PATH/venv/*

    for file in $dep_files; do
        if [ -f "$file" ]; then
            filename=$(basename $file | sed 's/\.[^.]*$//')
            name=${filename%@*}
            version=${filename#*@}

            echo -e "Creating $name with Python $version"

            env=$(pyenv create $name --global --version $version)
            $env/bin/pip install --requirement $file
        fi
    done
}


function conda_bundle {
    dep_files=$DEP_PATH/anaconda/*

    for file in $dep_files; do
        if [ -f "$file" ]; then
            conda env create - f $file
        fi
    done
}


function vscode_extensions {
    echo -e "Installing extensions ..."
    cat $DEP_PATH/vscode_extensions | xargs -n 1 code --install-extension
}

function vscode {
    read -p "Do you wish to install all VSCode extensions? [y/n] " RESP
    if [ "$RESP" = "y" ]; then
        vscode_extensions
    fi

    echo -e "Overwriting settings"
    if [[ $(uname) == "Darwin" ]]; then
        VSCODE_PATH=$HOME/Library/ApplicationSupport/Code/User
    else
        VSCODE_PATH=$HOME/.config/Code/User
    fi

    ln="ln -sf"

    for file in $SETTINGS_PATH/vscode/*; do
        if [ -f "$file" ]; then
            name=${file##*/}
            symlink=$VSCODE_PATH/$name
            $ln $file $symlink
            echo "Created Symlink of $name at $symlink"
        fi
    done
}