_red() { echo -e ${red}$*${plain}; }
_green() { echo -e ${green}$*${plain}; }
_yellow() { echo -e ${yellow}$*${plain}; }
_magenta() { echo -e ${magenta}$*${plain}; }
_cyan() { echo -e ${cyan}$*${plain}; }

_rm() {
	rm -rf "$@"
}
_cp() {
	cp -f "$@"
}
_sed() {
	sed -i "$@"
}
_mkdir() {
	mkdir -p "$@"
}

_load() {
    local _dir="/etc/v2ray/${magic}/v2ray/src/"
    . "${_dir}$@"
}