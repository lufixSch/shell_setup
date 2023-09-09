BASE_PATH=$HOME/shell_setup
DEP_PATH=$BASE_PATH/dependencies
SETTINGS_PATH=$BASE_PATH/settings

function brew_bundle {
    cd $DEP_PATH
    rm Brewfile
    brew bundle dump
}

function pacman_bundle {
    cd $DEP_PATH
    rm pacman.txt
    pacman -Qqe > pacman.txt
}

function kde_backup {
    cd $SETTINGS_PATH
    rm -rf kde
    mkdir kde
    mkdir kde/config
    mkdir kde/local
    cd kde
    cp -r $HOME/.config/k* ./config
    cp -r $HOME/.config/p* ./config
    cp -r $HOME/.config/latte ./config
    cp -r $HOME/.local/share/k* ./local
}

function python_bundle {
    for py in $(compgen -ac | grep -E '^python[0-9]+\.[0-9]+$'); do
        path=$DEP_PATH/python/$py.txt
        $py -m pip freeze > $path
        echo "Created dependency list for $py"
    done
}

function venv_bundle {
    for env in $(pyenv list --global --path); do
        env_path=${env%@*}

        path=$DEP_PATH/venv/$(basename $env).txt
        pyexec=$env_path/bin/python
        $pyexec -m pip freeze > $path
        echo "Created dependency list for $env"
    done
}

function conda_bundle {
    for env in $(conda env list | grep -Eo "^[^ #]+" | tr '\n' ' '); do
        path=$DEP_PATH/anaconda/$env.yml
        conda env export -n $env > $path
        echo "Created dependency list for $env"
    done
}

function npm_bundle {
    npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > $DEP_PATH/node
}

function omz_plugins {
    OMZ_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins

    rm -f $DEP_PATH/omz_plugins
    for file in $OMZ_DIR/*; do
        name=${file##*/}

        if [ $name != "example" ]; then
            echo -e "Detected Plugin: $name"
            cd "$file"
            git remote -v | sed '$ d' | awk '{ print $2 }' >> $DEP_PATH/omz_plugins
        fi
    done
}

function vscode {
    code --list-extensions | xargs -L 1 echo code --install-extension > $DEP_PATH/vscode_extensions
    echo -e "list of extensions saved"
}