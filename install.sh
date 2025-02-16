#! /bin/sh

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
	printf "\nI3 not found, not copying config files\n"
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

printf "\nConfiguring git\n\n- Commit author\n"

read -p "Enter user name: " _username
read -p "Enter user email: " _useremail

_tempfile=$(mktemp)

cat "gitconfig" > "${_tempfile}"

sed -i "s/<user>/${_username}/g" "${_tempfile}"
sed -i "s/<email>/${_useremail}/g" "${_tempfile}"

cp -a "${_tempfile}" "${HOME}/.gitconfig"

chmod 644 "${HOME}/.gitconfig"

rm ${_tempfile}

