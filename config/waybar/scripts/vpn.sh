#!/bin/bash

# Waybar custom/vpn module: report connected Pritunl profiles and live
# WireGuard interfaces as one status, on stdout as Waybar's JSON object.
#
# Unlike the other modules, this one carries its own icon rather than taking
# it from "format" in config.jsonc: a literal glyph there is printed even when
# the text is empty, which leaves a bare shield sitting in the bar with no VPN
# connected. Emitting the icon as part of the text keeps "nothing" empty.
_icon=$'\uf132'

_names=()
_details=()

# The Pritunl CLI talks to the user's own client service, so no root is needed.
# Its "watch" subcommand would push updates but demands a TTY, so this polls.
if command -v pritunl-client &> /dev/null
then
	while IFS=$'\t' read -r _name _address
	do
		[ -n "${_name}" ] || continue
		_names+=("${_name}")
		_details+=("pritunl: ${_name} (${_address:--})")
	done < <(pritunl-client list -j 2>/dev/null |
		jq -r '.[] | select(.connected) | [.name, .client_address] | @tsv')
fi

# "wg show" needs CAP_NET_ADMIN; enumerating the links does not.
while read -r _iface
do
	[ -n "${_iface}" ] || continue
	_names+=("${_iface}")
	_details+=("wireguard: ${_iface}")
done < <(ip -o link show type wireguard 2>/dev/null | awk -F': ' '{print $2}')

# Waybar hides a module whose text is empty, so "no VPN" leaves no gap.
if [ ${#_names[@]} -eq 0 ]
then
	printf '{"text":"","tooltip":"no VPN connection","class":"disconnected"}\n'
	exit 0
fi

_text="$(IFS=, ; printf '%s' "${_names[*]}")"
_text="${_text//,/, }"
_tooltip="$(printf '%s\\n' "${_details[@]}")"
_tooltip="${_tooltip%\\n}"

printf '{"text":"%s  %s","tooltip":"%s","class":"connected"}\n' \
	"${_icon}" "${_text}" "${_tooltip}"
