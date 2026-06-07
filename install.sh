#!/bin/bash
#
# Copyright (c) 2006-2026 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#

set -euo pipefail
NORMIFS=$IFS
SCRIFS=$'\n\t'
IFS=$SCRIFS

info() { echo -e "\\033[1;36m[INFO]\\033[0m  $*"; }
warn() { echo -e "\\033[1;33m[WARNING]\\033[0m  $*"; }
fatal() {
	echo -e "\\033[1;31m[FATAL]\\033[0m  $*"
	exit 1
}

RUBYSUFFIX=''

command_exists() {

	command -v "${1}" >/dev/null 2>&1
}

get_permission() {

	warn 'This script will install BeEF and its required dependencies (including operating system packages).'

	read -rp "Are you sure you wish to continue (Y/n)? "
	if [ "$(echo "${REPLY}" | tr "[:upper:]" "[:lower:]")" = "n" ]; then
		fatal 'Installation aborted'
	fi

}

check_os() {

	info "Detecting OS..."

	OS=$(uname)
	readonly OS
	info "Operating System: $OS"
	if [ "${OS}" = "Linux" ]; then
		info "Launching Linux install..."
		install_termux
	elif [ "${OS}" = "Darwin" ]; then
		info "Launching Mac OSX install..."
		install_mac
	elif [ "${OS}" = "FreeBSD" ]; then
		info "Launching FreeBSD install..."
		for SUFX in 32 31 30; do
			if command_exists ruby${SUFX}; then
				RUBYSUFFIX=${SUFX}
				break
			fi
		done
		install_freebsd
	elif [ "${OS}" = "OpenBSD" ]; then
		info "Launching OpenBSD install..."
		for SUFX in 32 31 30; do
			if command_exists ruby${SUFX}; then
				RUBYSUFFIX=${SUFX}
				break
			fi
		done
		install_openbsd
	else
		fatal "Unable to locate installer for your operating system: ${OS}"
	fi
}

install_termux() {

	info "Installing Termux prerequisites..."

	pkg update
	pkg upgrade -y

	info "Installing required packages..."
	pkg install -y curl git build-essential openssl libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool bison nodejs libcurl4-openssl-dev

	if command_exists rvm || command_exists rbenv; then
		info "Ruby package Manager exists - Ruby install skipped"
	else
		info "No Ruby package manager detected - will install Ruby"
		pkg install -y ruby-dev
	fi
}

install_openbsd() {

	pkg_add curl git libyaml libxml libxslt bison node ruby${RUBYSUFFIX}-bundler lame espeak
}

install_freebsd() {

	pkg install curl git libyaml libxslt devel/ruby-gems bison node espeak
}

install_mac() {

	local mac_deps=(curl git nodejs python3
		openssl readline libyaml sqlite3 libxml2
		autoconf ncurses automake libtool
		bison wget)

	if ! command_exists brew; then
		fatal "Homebrew (https://brew.sh/) required to install dependencies"
	fi

	info "Installing dependencies via brew"

	brew update

	for package in "${mac_deps[@]}"; do

		if brew install "${package}"; then
			info "${package} installed"
		else
			fatal "Failed to install ${package}"
		fi

	done
}

check_ruby_version() {

	info 'Detecting Ruby environment...'

	MIN_RUBY_VER='3.0'
	if command_exists ruby; then
		RUBY_VERSION=$(ruby -e "puts RUBY_VERSION")
		info "Ruby version ${RUBY_VERSION} is installed"
		if [ "$(ruby -e "puts RUBY_VERSION.to_f >= ${MIN_RUBY_VER}")" = 'false' ]; then
			fatal "Ruby version ${RUBY_VERSION} is not supported. Please install Ruby ${MIN_RUBY_VER} (or newer) and restart the installer."
		fi
	else
		fatal "Ruby is not installed. Please install Ruby ${MIN_RUBY_VER} (or newer) and restart the installer."
	fi
}

check_bundler() {

	info 'Detecting bundler gem...'

	if command_exists bundler; then
		info "bundler gem is installed"
	else
		info 'Installing bundler gem...'
		gem install bundler
	fi
}

install_beef() {

	echo "Installing required Ruby gems..."

	if [ -w Gemfile.lock ]; then
		/bin/rm Gemfile.lock
	fi

	if command_exists bundle; then
		bundle install
	else
		bundle install
	fi
}

finish() {
	echo
	echo "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#"
	echo
	info "Install completed successfully!"
	info "Run './beef' to launch BeEF"
	echo
	echo "Next steps:"
	echo
	echo "* Change the default password in config.yaml"
	echo "* Configure geoipupdate to update the Maxmind GeoIP database:"
	echo "*   https://dev.maxmind.com/geoip/updating-databases"
	echo "* Review the wiki for important configuration information:"
	echo "  https://github.com/beefproject/beef/wiki/Configuration"
	echo
	echo "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#"
	echo
}

main() {

	clear

	if [ -f core/main/console/beef.ascii ]; then
		cat core/main/console/beef.ascii
		echo
	fi


	if [ -n "${GITACTIONS:-}" ]; then
		info "Skipping: Running on Github Actions"
	else
		get_permission
	fi
	check_os
	check_ruby_version
	check_bundler
	install_beef
	finish
}

main "$@"
