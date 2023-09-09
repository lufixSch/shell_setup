# Shell Setup

Scripts for easy shell backup/setup

At the moment the script supports MacOS with Homebrew and Manjaro Linux with KDE Plasma DE. The following configurations are saved:

- Homebrew packages (Only MacOS)
- Pacman packages (Only Linux)
- KDE configuration (Only Linux)
- LatteDock configuration (Only Linux)
- Dotfiles
- Python dependencies
- Global venv dependencies (Only when the `pyenv` script is used)
- Global NPM packages
- VSCode settings and keyboard shortcuts
- VSCode extensions
- OMZ setup
- OMZ plugins

> DISCLAIMER: At the moment it is not possible to only backup specific data. It might work even if you don't use all the tools listed above but there is no guarantee

## Usage

create a private Fork of this repository and clone it into your `$HOME` directory. Add the `bin/` folder to your path.

Create backups using `shell-backup`.

> Before the first backup you might move the dotfiles you want to backup into the folder `$HOME/shell_setup/dotfiles` and create a symbolic link in your `$HOME` directory

If you have an existing backup clone your repository into the `$HOME` of a new machine and run `shell-setup`

## Other Scripts

This repo also contains some simple utility scripts

### pyenv

Script which makes the usage of python venv easier. Allows you to create global or local environments and manage them. Backup of the global environments (dependencies) is supported by the backup script

### executable

Make a file executable (same as `chmod 755`,I am just lazy)

### sf

> MacOS only

Show/hide hidden files in Finder

```bash
sf TRUE # Show hidden files
sf FALSE # Hide files
```

### discord-activate-vcam

Remove Discord's code signature so it can be used with VCam (might be unnecessary now)