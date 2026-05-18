#!/bin/bash

printf "Installing configuration in ${HOME}\n"

if command -v zsh &> /dev/null
then
	printf "\nZSH is installed, copying config\n"
	cp "zshrc" "${HOME}/.zshrc"
	if [ ! -d "${HOME}/.config/zsh" ]; then
		mkdir -p "${HOME}/.config/zsh"
	fi
	cp -a "config/zsh/." "${HOME}/.config/zsh"
else
	printf "\nZSH not found, not copying config files\n"
fi

if command -v i3 &> /dev/null
then
	printf "\nI3 is installed, copying config\n"
	if [ ! -d "${HOME}/.config/i3" ]; then
		mkdir -p "${HOME}/.config/i3"
	fi
	cp -a "config/i3/." "${HOME}/.config/i3"
else
	printf "\nI3 not found, not copying config files\n"
fi

if command -v i3status &> /dev/null
then
	printf "\nI3status is installed, copying config\n"
	if [ ! -d "${HOME}/.config/i3status" ]; then
		mkdir -p "${HOME}/.config/i3status"
	fi
	cp -a "config/i3status/." "${HOME}/.config/i3status"
else
	printf "\nI3status not found, not copying config files\n"
fi

if command -v sway &> /dev/null
then
	printf "\nSway is installed, copying config\n"
	if [ ! -d "${HOME}/.config/sway" ]; then
		mkdir -p "${HOME}/.config/sway"
	fi
	cp -a "config/sway/." "${HOME}/.config/sway"
else
	printf "\nSway not found, not copying config files\n"
fi

if command -v waybar &> /dev/null
then
	printf "\nWaybar is installed, copying config\n"
	if [ ! -d "${HOME}/.config/waybar" ]; then
		mkdir -p "${HOME}/.config/waybar"
	fi
	cp -a "config/waybar/." "${HOME}/.config/waybar"
else
	printf "\nWaybar not found, not copying config files\n"
fi

if command -v fuzzel &> /dev/null
then
	printf "\nFuzzel is installed, copying config\n"
	if [ ! -d "${HOME}/.config/fuzzel" ]; then
		mkdir -p "${HOME}/.config/fuzzel"
	fi
	cp -a "config/fuzzel/." "${HOME}/.config/fuzzel"
else
	printf "\nFuzzel not found, not copying config files\n"
fi

if command -v mako &> /dev/null
then
	printf "\nMako is installed, copying config\n"
	if [ ! -d "${HOME}/.config/mako" ]; then
		mkdir -p "${HOME}/.config/mako"
	fi
	cp -a "config/mako/." "${HOME}/.config/mako"
else
	printf "\nMako not found, not copying config files\n"
fi

if command -v alacritty &> /dev/null
then
	printf "\nAlacritty is installed, copying config\n"
	if [ ! -d "${HOME}/.config/alacritty" ]; then
		mkdir -p "${HOME}/.config/alacritty"
	fi
	cp -a "config/alacritty/." "${HOME}/.config/alacritty"
else
	printf "\nAlacritty not found, not copying config files\n"
fi

if command -v nvim &> /dev/null
then
	printf "\nNeovim is installed, copying config\n"
	if [ ! -d "${HOME}/.config/nvim" ]; then
		mkdir -p "${HOME}/.config/nvim"
	fi
	cp -a "config/nvim/." "${HOME}/.config/nvim"
else
	printf "\nNvim not found, not copying config files\n"
fi

printf "\nConfiguring git\n"

if command -v git &> /dev/null
then
	_current_name="$(git config --global user.name)"
	_current_email="$(git config --global user.email)"

	printf "\nCurrent git commit author:\n"
	printf "  name:  %s\n" "${_current_name:-<unset>}"
	printf "  email: %s\n" "${_current_email:-<unset>}"

	read -p "Update the git commit author? [y/N] " _answer
	case "${_answer}" in
		[Yy]*)
			read -p "Enter user name: " _username
			read -p "Enter user email: " _useremail

			_tempfile=$(mktemp)
			cat "gitconfig" > "${_tempfile}"
			sed -i "s/<user>/${_username}/g" "${_tempfile}"
			sed -i "s/<email>/${_useremail}/g" "${_tempfile}"
			cp -a "${_tempfile}" "${HOME}/.gitconfig"
			chmod 644 "${HOME}/.gitconfig"
			rm "${_tempfile}"
			printf "Git commit author updated.\n"
			;;
		*)
			printf "Keeping the existing git configuration.\n"
			;;
	esac
else
	printf "\nGit not found, skipping git configuration\n"
fi

