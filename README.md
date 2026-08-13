```txt
 ▒██▒   ░██▓  ▓▓▓▓▓████░
 ▒██▒   ░██▓     ░▓██▓░
 ▒██▒   ░██▓    ▓███░
 ▒██▓   ▓██▓  ▒███▒░░░░
 ▒█████████▓ ▒█████████▓ zsh micro plugin manager
 ▒██▒░░░░░░  ░░░░░░░░░░
 ▒██▒
  ░░░
```

![GitHub file size in bytes](https://img.shields.io/github/size/maxrodrigo/uz/uz.zsh?color=green&label=uz.zsh&logo=uz.zsh%20size&style=flat-square)
![CI](https://img.shields.io/github/actions/workflow/status/maxrodrigo/uz/ci.yml?branch=master&style=flat-square&label=CI)

## Installation

### Git

Clone from GitHub and source `uz.zsh`.

```sh
git clone https://github.com/maxrodrigo/uz.git ~/.uz
```

```zsh
# ~/.zshrc
source ~/.uz/uz.zsh
```

To update, `git -C ~/.uz pull`.

### Homebrew

```sh
brew install maxrodrigo/tap/uz
```

```zsh
# ~/.zshrc
source $(brew --prefix)/share/uz/uz.zsh
```

To update, `brew upgrade uz`.

## Usage

### Add Plugins

Add plugins' Github repo to `.zshrc` with `zadd`. Plugins are automatically installed on load.

```zsh
zadd zsh-users/zsh-syntax-highlighting
zadd zsh-users/zsh-completions
```

By default `µz` sources `init.zsh` or `plugin_name.(zsh|plugin.zsh|zsh-theme|sh)` but you can also specify another script to the `zadd` command as follows:

```zsh
zadd username/repo script_name
```

### Manage Plugins

- `zclean`: removes plugins no longer in `.zshrc`.
- `zupdate`: update installed plugins.

### Installation Path

By default plugins are installed into `${XDG_DATA_HOME:-~/.local/share}/uz/plugins`,
independent of where `uz.zsh` itself is installed from — this matters if it's
managed by a package manager that replaces its install directory on every
upgrade (see [Homebrew](#homebrew)). This behavior can be changed re-setting `UZ_PLUGIN_PATH`.

Plugins are namespaced by owner (`${UZ_PLUGIN_PATH}/owner/repo`), so two
different forks of the same repo name never collide. Upgrading from an older
`μz` that installed plugins flat, or at the old default path next to `uz.zsh`,
migrates each one automatically on its next `zadd` — no re-clone, existing
`.git` history and compiled `.zwc` are kept.

```zsh
export UZ_PLUGIN_PATH=${XDG_DATA_HOME:-$HOME/.local/share}/uz/plugins # default
```

## Example

```zsh
# ~/.zshrc
source ~/.uz/uz.zsh

zadd maxdrorigo/gitster
zadd maxrodrigo/zsh-kubernetes-contexts
zadd zsh-users/zsh-syntax-highlighting
zadd zsh-users/zsh-history-substring-search
zadd zsh-users/zsh-completions
```

## Requirements

- `zsh`
- `git`

## Uninstall

### Git

`μz` only creates folders for the cloned modules and, by default, are self contained into the installation directory.

To uninstall remove the installation directory (`$UZ_PATH`) and the modules folder (`$UZ_PLUGIN_PATH`) if applicable.

### Homebrew

```sh
brew uninstall uz
```

Plugins live outside the formula's install directory (see [Installation
Path](#installation-path)), so uninstalling doesn't remove them; delete
`$UZ_PLUGIN_PATH` too if applicable.

## Other Notes

### Testing

`test/.zshrc` sources this repo's own `uz.zsh` into an isolated
`UZ_PLUGIN_PATH` (`test/plugins`, gitignored), so changes can be verified
without touching your real dotfiles:

```sh
ZDOTDIR=$PWD/test zsh -i
```

First run clones the plugins listed in `test/.zshrc`; edit that file to add
more. Delete `test/plugins` to start clean.

### Releasing

```sh
make release
```

Tags and pushes a new version, then points the [Homebrew formula](#homebrew)
at it — downloads the tag's tarball, recomputes its checksum, and pushes the
update straight to `maxrodrigo/tap`. No CI, no per-platform builds; `uz` is
one portable script. Run `make brew VERSION=vX.Y.Z` alone to repoint the
formula without cutting a new release.

### Updating benchmark

```sh
ls -d ${UZ_PLUGIN_PATH}/*/.git
0.00s user 0.00s system 77% cpu 0.002 total

find $UZ_PLUGIN_PATH -type d -name .git -prune
0.01s user 0.00s system 95% cpu 0.006 total

find $UZ_PLUGIN_PATH -type d -exec test -e '{}/.git' \; -print0
0.19s user 0.09s system 100% cpu 0.286 total
```

### Compile benchmark

`zadd` compiles each sourced script to bytecode (`.zwc`) via `zcompile`, so
every following shell loads it instead of re-parsing text. Sourcing
`zsh-autosuggestions.zsh` (867 lines) 500 times, with and without its `.zwc`:

```sh
source zsh-autosuggestions.zsh # with .zwc
0.06s user 0.03s system 99% cpu 0.092 total

source zsh-autosuggestions.zsh # without .zwc
0.25s user 0.07s system 99% cpu 0.315 total
```
