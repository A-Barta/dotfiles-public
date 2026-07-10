# `dotfiles-public`

> ⚙️ Configuration files to carry the same environment wherever I go.
> 🐧 I use Arch, btw.

## ⚠️ The repo is the live config

`install.sh` symlinks `$HOME` at this repo rather than copying into it, so a
file opened from `~/.config/` *is* the file in this checkout.
**Edit here and push. Moving or deleting this repo breaks every deployed config.**

Nothing is overwritten: if a destination already exists and is not a symlink,
`install.sh` reports it and skips, leaving you to remove it.

## 🧰 The setup

| Area            | Tools                                   |
| --------------- | --------------------------------------- |
| Terminal        | `alacritty`, `zsh`                      |
| Editor          | `neovim`                                |
| X11 desktop     | `i3` + `i3status`                       |
| Wayland desktop | `sway` + `waybar` + `fuzzel` + `mako`   |
| VCS             | `git`                                   |

Each tool's config is installed only if that tool is found on the system.

## 🚀 Installation

```sh
git clone <this-repo>
cd dotfiles-public
./install.sh
```

`install.sh`:

1. Reports any missing runtime dependencies, with the `pacman` or `dnf` command
   to fix them. Arch and Rocky (RHEL) are recognised; derivatives resolve to
   their parent via `ID_LIKE`.
2. Symlinks each config into `$HOME`.
3. Optionally updates the git commit author in `~/.gitconfig`.

## 🗂️ Layout

```
zshrc                → ~/.zshrc
config/<tool>/       → ~/.config/<tool>/
gitconfig            → ~/.gitconfig   (copied, not linked: name/email
                                       are filled in at install time)
```

`~/.config/zsh` and `~/.config/sway` also hold files this repo does not carry
(`aliasrc_private`, `aliasrc_maxiv`, `outputs.d/`), so only the file this repo
owns is linked, not the whole directory:

```
config/zsh/aliasrc   → ~/.config/zsh/aliasrc
config/sway/config   → ~/.config/sway/config
```
