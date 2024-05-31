#! /bin/sh

echo "Installing configuration in ${HOME}"

if command -v zsh &> /dev/null
then
	echo "ZSH is installed, copying config"
	cp ".zshrc" "${HOME}/.zshrc"
	if [ ! -d "${HOME}/.config/zsh" ]; then
		mkdir -p "${HOME}/.config/zsh"
	fi
	cp -a ".config/zsh/." "${HOME}/.config/zsh"
else
	echo "ZSH not found, not copying config files"
fi

if command -v i3 &> /dev/null
then
	echo "I3 is installed, copying config"
	if [ ! -d "${HOME}/.config/i3" ]; then
		mkdir -p "${HOME}/.config/i3"
	fi
	cp -a ".config/i3/." "${HOME}/.config/i3"
else
	echo "I3 not found, not copying config files"
fi

if command -v i3status &> /dev/null
then
	echo "I3status is installed, copying config"
	if [ ! -d "${HOME}/.config/i3status" ]; then
		mkdir -p "${HOME}/.config/i3status"
	fi
	cp -a ".config/i3status/." "${HOME}/.config/i3status"
else
	echo "I3status not found, not copying config files"
fi

if command -v alacritty &> /dev/null
then
	echo "Alacritty is installed, copying config"
	if [ ! -d "${HOME}/.config/alacritty" ]; then
		mkdir -p "${HOME}/.config/alacritty"
	fi
	cp -a ".config/alacritty/." "${HOME}/.config/alacritty"
else
	echo "Alacritty not found, not copying config files"
fi

if command -v nvim &> /dev/null
then
	echo "Neovim is installed, copying config"
	if [ ! -d "${HOME}/.config/nvim" ]; then
		mkdir -p "${HOME}/.config/nvim"
	fi
	cp -a ".config/nvim/." "${HOME}/.config/nvim"
else
	echo "Nvim not found, not copying config files"
fi

echo "Copying git configuration"
cp -a ".gitconfig" "${HOME}/.gitconfig"

