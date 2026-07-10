#!/bin/bash

# install.sh — deploy these dotfiles into $HOME.
# Each tool's config is linked only if that tool is installed.

# Deployed configs are symlinks into this repo, so moving the repo breaks them.
_repo="$(cd "$(dirname "$0")" && pwd)"

#   link_into_home <source-path> <destination-path>
link_into_home() {
	local src="$1" dest="$2"

	if [ -e "${dest}" ] && [ ! -L "${dest}" ]
	then
		printf "  ! %s exists and is not a symlink; remove it and re-run\n" "${dest}"
		return 1
	fi

	mkdir -p "$(dirname "${dest}")"
	ln -sfn "${_repo}/${src}" "${dest}"
}

#   install_config <command> <source-path> <destination-path>
install_config() {
	local cmd="$1" src="$2" dest="$3"
	if ! command -v "${cmd}" &> /dev/null
	then
		printf "  ✗ %s (not installed, skipped)\n" "${cmd}"
		return
	fi

	link_into_home "${src}" "${dest}" && printf "  ✓ %s\n" "${cmd}"
}

printf "Installing dotfiles into %s\n" "${HOME}"

# --- Dependencies --------------------------------------------------------
# These configs invoke extra commands at runtime. Everything is installed
# regardless; this only reports what is missing.
printf "\nDependencies\n"

declare -A _deps=(
	[zsh]=zsh
	[i3]=i3-wm
	[i3status]=i3status
	[sway]=sway
	[waybar]=waybar
	[fuzzel]=fuzzel
	[mako]=mako
	[cliphist]=cliphist
	[wl-copy]=wl-clipboard
	[wl-clip-persist]=wl-clip-persist
	[alacritty]=alacritty
	[nvim]=neovim
	[git]=git
	[dex]=dex
	[wpctl]=wireplumber
	[brightnessctl]=brightnessctl
	[grim]=grim
	[slurp]=slurp
	[swaylock]=swaylock
	[pavucontrol]=pavucontrol
	[lf]=lf
	[feh]=feh
	[picom]=picom
	[i3lock]=i3lock
	[nm-applet]=network-manager-applet
)

_missing_pkgs=""
for _cmd in $(printf '%s\n' "${!_deps[@]}" | sort)
do
	if ! command -v "${_cmd}" &> /dev/null
	then
		printf "  ✗ %-14s (package: %s)\n" "${_cmd}" "${_deps[$_cmd]}"
		_missing_pkgs="${_missing_pkgs} ${_deps[$_cmd]}"
	fi
done

if [ -n "${_missing_pkgs}" ]
then
	printf "  install the missing commands with:\n"
	printf "    sudo pacman -S%s\n" "${_missing_pkgs}"
else
	printf "  ✓ all expected commands are available\n"
fi

# --- Configs -------------------------------------------------------------
printf "\nConfigs\n"

# zsh also gets ~/.zshrc, on top of ~/.config/zsh.
command -v zsh &> /dev/null && link_into_home "zshrc" "${HOME}/.zshrc"

# These dirs also hold machine-local files (aliasrc_private, outputs.d/),
# so only the repo-owned file is linked, not the directory.
install_config zsh       config/zsh/aliasrc "${HOME}/.config/zsh/aliasrc"
install_config sway      config/sway/config "${HOME}/.config/sway/config"

install_config i3        config/i3        "${HOME}/.config/i3"
install_config i3status  config/i3status  "${HOME}/.config/i3status"
install_config waybar    config/waybar    "${HOME}/.config/waybar"
install_config fuzzel    config/fuzzel    "${HOME}/.config/fuzzel"
install_config mako      config/mako      "${HOME}/.config/mako"
install_config alacritty config/alacritty "${HOME}/.config/alacritty"
install_config nvim      config/nvim      "${HOME}/.config/nvim"

# --- Git -----------------------------------------------------------------
printf "\nGit\n"

if command -v git &> /dev/null
then
	_current_name="$(git config --global user.name)"
	_current_email="$(git config --global user.email)"

	printf "  current commit author:\n"
	printf "    name:  %s\n" "${_current_name:-<unset>}"
	printf "    email: %s\n" "${_current_email:-<unset>}"

	read -p "  update the git commit author? [y/N] " _answer
	case "${_answer}" in
		[Yy]*)
			read -p "    user name:  " _username
			read -p "    user email: " _useremail

			_tempfile=$(mktemp)
			cat "gitconfig" > "${_tempfile}"
			sed -i "s/<user>/${_username}/g" "${_tempfile}"
			sed -i "s/<email>/${_useremail}/g" "${_tempfile}"
			cp -a "${_tempfile}" "${HOME}/.gitconfig"
			chmod 644 "${HOME}/.gitconfig"
			rm "${_tempfile}"
			printf "  ✓ git commit author updated\n"
			;;
		*)
			printf "  ✓ kept the existing git configuration\n"
			;;
	esac
else
	printf "  ✗ git not installed, skipped\n"
fi

printf "\nDone.\n"
