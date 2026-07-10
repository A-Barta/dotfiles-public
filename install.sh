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
# Nothing is installed here; missing commands are only reported.
# A package name of "-" means the command has no package on that distribution.
printf "\nDependencies\n"

# ID_LIKE resolves derivatives to their parent: manjaro -> arch, alma -> rhel.
detect_os() {
	local _id _id_like
	if [ -r /etc/os-release ]
	then
		# Subshell keeps os-release's variables out of this script's scope.
		_id="$(. /etc/os-release && printf '%s' "${ID:-}")"
		_id_like="$(. /etc/os-release && printf '%s' "${ID_LIKE:-}")"
	fi

	case " ${_id} ${_id_like} " in
		*" arch "*)                            printf 'arch'    ;;
		*" rhel "* | *" fedora "* | *" centos "*) printf 'rocky'   ;;
		*)                                     printf 'unknown' ;;
	esac
}

_os="$(detect_os)"

declare -A _install_cmd=(
	[arch]="sudo pacman -S --needed"
	[rocky]="sudo dnf install"
)

_commands=(
	git zsh nvim tree
	tree-sitter gcc make curl unzip rg fd npm
	sway swaybg swaylock waybar fuzzel mako cliphist wl-copy wl-clip-persist
	grim slurp grimshot Xwayland pkexec
	i3 i3status i3lock picom feh rofi
	alacritty dex wpctl brightnessctl pavucontrol lf nm-applet firefox
	pipewire pw-cat amixer volumeicon
	keepassxc nextcloud libreoffice mqtt-explorer
	ipython pre-commit gopls virtualenvwrapper.sh
)

# On Rocky most of the desktop packages live in EPEL, not the base repos.
declare -A _packages=(
	[arch:git]=git                         [rocky:git]=git
	[arch:zsh]=zsh                         [rocky:zsh]=zsh
	[arch:nvim]=neovim                     [rocky:nvim]=neovim

	[arch:tree-sitter]=tree-sitter-cli     [rocky:tree-sitter]=-
	[arch:gcc]=gcc                         [rocky:gcc]=gcc
	[arch:make]=make                       [rocky:make]=make
	[arch:curl]=curl                       [rocky:curl]=curl
	[arch:unzip]=unzip                     [rocky:unzip]=unzip
	[arch:rg]=ripgrep                      [rocky:rg]=ripgrep
	[arch:fd]=fd                           [rocky:fd]=fd-find

	[arch:sway]=sway                       [rocky:sway]=sway
	[arch:swaylock]=swaylock               [rocky:swaylock]=swaylock
	[arch:waybar]=waybar                   [rocky:waybar]=waybar
	[arch:fuzzel]=fuzzel                   [rocky:fuzzel]=-
	[arch:mako]=mako                       [rocky:mako]=mako
	[arch:cliphist]=cliphist               [rocky:cliphist]=-
	[arch:wl-copy]=wl-clipboard            [rocky:wl-copy]=wl-clipboard
	[arch:wl-clip-persist]=wl-clip-persist [rocky:wl-clip-persist]=-
	[arch:grim]=grim                       [rocky:grim]=grim
	[arch:slurp]=slurp                     [rocky:slurp]=slurp
	[arch:grimshot]=grimshot               [rocky:grimshot]=-

	[arch:i3]=i3-wm                        [rocky:i3]=i3
	[arch:i3status]=i3status               [rocky:i3status]=i3status
	[arch:i3lock]=i3lock                   [rocky:i3lock]=i3lock
	[arch:picom]=picom                     [rocky:picom]=picom
	[arch:feh]=feh                         [rocky:feh]=feh

	[arch:alacritty]=alacritty             [rocky:alacritty]=alacritty
	[arch:dex]=dex                         [rocky:dex]=-
	[arch:wpctl]=wireplumber               [rocky:wpctl]=wireplumber
	[arch:brightnessctl]=brightnessctl     [rocky:brightnessctl]=brightnessctl
	[arch:pavucontrol]=pavucontrol         [rocky:pavucontrol]=pavucontrol
	[arch:lf]=lf                           [rocky:lf]=-
	[arch:nm-applet]=network-manager-applet [rocky:nm-applet]=network-manager-applet
	[arch:firefox]=firefox                 [rocky:firefox]=firefox

	[arch:tree]=tree                       [rocky:tree]=tree
	[arch:npm]=npm                         [rocky:npm]=npm
	[arch:swaybg]=swaybg                   [rocky:swaybg]=swaybg
	[arch:rofi]=rofi                       [rocky:rofi]=rofi
	[arch:pkexec]=polkit                   [rocky:pkexec]=polkit
	[arch:Xwayland]=xorg-xwayland          [rocky:Xwayland]=xorg-x11-server-Xwayland
	[arch:pipewire]=pipewire               [rocky:pipewire]=pipewire
	[arch:pw-cat]=pipewire-audio           [rocky:pw-cat]=pipewire-utils
	[arch:amixer]=alsa-utils               [rocky:amixer]=alsa-utils
	[arch:volumeicon]=volumeicon           [rocky:volumeicon]=-
	[arch:keepassxc]=keepassxc             [rocky:keepassxc]=keepassxc
	[arch:nextcloud]=nextcloud-client      [rocky:nextcloud]=nextcloud-client
	[arch:libreoffice]=libreoffice-fresh   [rocky:libreoffice]=libreoffice
	[arch:mqtt-explorer]=mqtt-explorer     [rocky:mqtt-explorer]=-
	[arch:ipython]=ipython                 [rocky:ipython]=python3-ipython
	[arch:pre-commit]=pre-commit           [rocky:pre-commit]=pre-commit
	[arch:gopls]=gopls                     [rocky:gopls]=-
	[arch:virtualenvwrapper.sh]=python-virtualenvwrapper [rocky:virtualenvwrapper.sh]=-
)

# These install no command, so they are checked by package name instead.
_extras=( hack-nf-mono-git noto-fonts-emoji pipewire-alsa esp-idf )

declare -A _extra_packages=(
	[arch:hack-nf-mono-git]=hack-nf-mono-git [rocky:hack-nf-mono-git]=-
	[arch:noto-fonts-emoji]=noto-fonts-emoji [rocky:noto-fonts-emoji]=google-noto-emoji-fonts
	[arch:pipewire-alsa]=pipewire-alsa       [rocky:pipewire-alsa]=pipewire-alsa
	[arch:esp-idf]=esp-idf                   [rocky:esp-idf]=-
)

pkg_installed() {
	case "${_os}" in
		arch)  pacman -Qq "$1" &> /dev/null ;;
		rocky) rpm -q "$1"     &> /dev/null ;;
		*)     return 1 ;;
	esac
}

_missing_pkgs=""
_unpackaged=""
_any_missing=""

for _cmd in "${_commands[@]}"
do
	command -v "${_cmd}" &> /dev/null && continue
	_any_missing=1

	_pkg="${_packages[${_os}:${_cmd}]}"

	if [ "${_os}" = "unknown" ] || [ -z "${_pkg}" ]
	then
		printf "  ✗ %-16s (unknown package)\n" "${_cmd}"
	elif [ "${_pkg}" = "-" ]
	then
		printf "  ✗ %-16s (no %s package)\n" "${_cmd}" "${_os}"
		_unpackaged="${_unpackaged} ${_cmd}"
	else
		printf "  ✗ %-16s (package: %s)\n" "${_cmd}" "${_pkg}"
		case " ${_missing_pkgs} " in
			*" ${_pkg} "*) ;;
			*) _missing_pkgs="${_missing_pkgs} ${_pkg}" ;;
		esac
	fi
done

for _extra in "${_extras[@]}"
do
	_pkg="${_extra_packages[${_os}:${_extra}]}"

	if [ "${_os}" = "unknown" ] || [ -z "${_pkg}" ]
	then
		printf "  ✗ %-16s (unknown package)\n" "${_extra}"
		_any_missing=1
	elif [ "${_pkg}" = "-" ]
	then
		printf "  ✗ %-16s (no %s package)\n" "${_extra}" "${_os}"
		_unpackaged="${_unpackaged} ${_extra}"
		_any_missing=1
	elif ! pkg_installed "${_pkg}"
	then
		printf "  ✗ %-16s (package: %s)\n" "${_extra}" "${_pkg}"
		_any_missing=1
		case " ${_missing_pkgs} " in
			*" ${_pkg} "*) ;;
			*) _missing_pkgs="${_missing_pkgs} ${_pkg}" ;;
		esac
	fi
done

if [ -z "${_any_missing}" ]
then
	printf "  ✓ all expected commands are available\n"
fi

if [ -n "${_missing_pkgs}" ]
then
	printf "  install the missing commands with:\n"
	printf "    %s%s\n" "${_install_cmd[${_os}]}" "${_missing_pkgs}"
fi

if [ -n "${_unpackaged}" ]
then
	printf "  no %s package for:%s\n" "${_os}" "${_unpackaged}"
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
