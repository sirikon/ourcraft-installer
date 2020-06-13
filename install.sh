#!/usr/bin/env bash
set -euo pipefail

TEMP_FOLDER="/tmp/ourcraft-installer"
DEB_FILE_PATH="${TEMP_FOLDER}/ourcraft.deb"

function main {
	create-temp-folder

	download-latest-deb
	install-deb
	display-final-message

	destroy-temp-folder
}

function download-latest-deb {
	printf "Downloading latest deb..."
	curl -Lso "${DEB_FILE_PATH}" "$(get-latest-release-deb)"
	printf " OK\n"
}

function install-deb {
	printf "Installing downloaded deb using APT\n"
	apt-get install -y "${DEB_FILE_PATH}"
}

function display-final-message {
	printf "\n"
	printf "Ourcraft installation done!\n"
	printf "Run 'apt-get remove ourcraft' to uninstall\n"
	printf "\n"
}

function get-latest-release-deb {
	get-latest-release-assets \
		| grep -e '\.deb$' \
		| head -n 1
}

function get-latest-release-assets {
	get-latest-release \
		| jq -r '.assets[].browser_download_url'
}

function get-latest-release {
	curl -s https://api.github.com/repos/sirikon/ourcraft/releases/latest
}

function create-temp-folder {
	destroy-temp-folder
	mkdir -p "$TEMP_FOLDER"
}

function destroy-temp-folder {
	rm -rf "$TEMP_FOLDER"
}

main
