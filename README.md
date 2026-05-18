# `dotfiles-public`

> ⚙️ Configuration files to carry the same environment wherever I go.
> 🐧 I use Arch, btw.

## ⚠️ By design, there are no backups

`install.sh` overwrites live config files in `$HOME` with no backup.
**The repo is the source of truth — edit files here and push. Never edit them locally.**

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

1. Reports any missing runtime dependencies (with the `pacman` command to fix them).
2. Copies each config into `$HOME` — `zshrc` → `~/.zshrc`, `config/<tool>/` → `~/.config/<tool>/`.
3. Optionally updates the git commit author in `~/.gitconfig`.

## 🗂️ Layout

```
zshrc            → ~/.zshrc
gitconfig        → ~/.gitconfig   (name/email filled in at install time)
config/<tool>/   → ~/.config/<tool>/
```
