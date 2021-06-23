```txt
 /$$   /$$ /$$$$$$$$
| $$  | $$|____ /$$/
| $$  | $$   /$$$$/
| $$  | $$  /$$__/
| $$$$$$$/ /$$$$$$$$  zsh micro plugin manager
| $$____/ |________/
| $$
| $$
 \_$
```

## Installation

Clone from GitHub and source `uz.zsh`.

```sh
git clone https://github.com/maxrodrigo/uz.git ~/.uz
```

```zsh
# ~/.zshrc
source ~/.uz/uz.zsh
```

## Usage

### Add Plugins

Add plugins' Github repo to `.zshrc` with `zadd`. Plugins are automatically installed on load.

```zsh
zadd zsh-users/zsh-syntax-highlighting
zadd zsh-users/zsh-completions
```
### Manage Plugins

- `zclean`: removes plugins no longer in `.zshrc`.
- `zupdate`: update installed plugins.

### Installation Path

By default plugins are installed into `~/${UZ_PATH}/plugins`. This behavior can be changed setting `UZ_PLUGIN_PATH`.

```zsh
export UZ_PLUGIN_PATH=${UZ_PATH}/plugins # default
```

## Example

```zsh
# ~/.zshrc
source ~/.uz/uz.zsh

# Plugins
zadd zimfw/history
zadd zsh-users/zsh-syntax-highlighting
zadd zsh-users/zsh-history-substring-search
zadd zsh-users/zsh-autosuggestions
zadd zsh-users/zsh-completions
```

## Requirements

- `zsh`
- `git`

## Uninstall

`μz` only creates folders for the cloned modules and, by default, are self contained into the installation directory.

To uninstall remove the installation directory (`$UZ_PATH`) and the modules folder (`$UZ_PLUGIN_PATH`) if applicable.

## Other Notes

### Updating benchmark


```sh
ls -d ${UZ_PLUGIN_PATH}/*/.git
0.00s user 0.00s system 77% cpu 0.002 total

find $UZ_PLUGIN_PATH -type d -name .git -prune
0.01s user 0.00s system 95% cpu 0.006 total

find $UZ_PLUGIN_PATH -type d -exec test -e '{}/.git' \; -print0
0.19s user 0.09s system 100% cpu 0.286 total
```
