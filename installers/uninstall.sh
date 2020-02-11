#!/usr/bin/env bash

: '
%file uninstall.sh
%author Sam Freeside (@snovvcrash) <snovvcrash@protonmail[.]ch>
%date 2018-05-28

%brief usbrip uninstaller.

%license
Copyright (C) 2020 Sam Freeside

This file is part of usbrip.

usbrip is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

usbrip is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with usbrip.  If not, see <http://www.gnu.org/licenses/>.
%endlicense
'

# Usage: sudo bash installers/uninstall.sh [-a/--all]

# --------------- Check for root privileges ----------------

if [[ $EUID -ne 0 ]]; then
	/usr/bin/printf "${R}>>>>${NC} Please run as root:\nsudo %s [-a/--all]\n" "${0}"
	exit 1
fi

# ----------------------- Constants ------------------------

if [[ -z "${SUDO_USER}" ]]; then
	SUDO_USER="root"
fi

USER_HOME=`getent passwd ${SUDO_USER} | cut -d: -f6`
CONFIG="${USER_HOME}/.config/usbrip"

OPT="/opt/usbrip"
VAR_OPT="/var/opt/usbrip"
SYMLINK="/usr/local/bin/usbrip"

G="\033[1;32m"  # GREEN
R="\033[1;31m"  # RED
NC="\033[0m"    # NO COLOR

# ----------------------- Functions ------------------------

remove_directory() {
	if /bin/rm -r "$1" 2> /dev/null; then
		/usr/bin/printf "${G}>>>>${NC} Removed directory: '$1'\n"
	fi
}

# -------------------- Handle switches ---------------------

if [[ "$1" == "-a" ]] || [[ "$1" == "--all" ]]; then
	ALL=true
else
	ALL=false
fi

# ------------------- Remove directories -------------------

# OPT

remove_directory "${OPT}"

# VAR_OPT

remove_directory "${VAR_OPT}"

# CONFIG

remove_directory "${CONFIG}"

# --------------------- Remove symlink ---------------------

if /bin/rm "${SYMLINK}" 2> /dev/null; then
	/usr/bin/printf "${G}>>>>${NC} Removed symlink: '${SYMLINK}'\n"
fi

# -------------------------- Done --------------------------

/usr/bin/printf "${G}>>>>${NC} Done.\n"
