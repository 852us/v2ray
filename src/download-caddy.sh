_get_latest_version() {
  caddy_repos_url="https://api.github.com/repos/caddyserver/caddy/releases/latest?v=$RANDOM"
  caddy_latest_ver="$(curl -s $caddy_repos_url | grep 'tag_name' | cut -d\" -f4)" # awk -F \" '{print $4}'

	if [[ ! $caddy_latest_ver ]]; then
		echo
		echo -e " $red获取 Caddy 最新版本失败!!!$none"
		echo
		echo -e " 请尝试执行如下命令: $green echo 'nameserver 8.8.8.8' >/etc/resolv.conf $none"
		echo
		echo " 然后再重新运行脚本...."
		echo
		exit 1
	fi
}

_download_caddy_file() {
  caddy_repos_url="https://api.github.com/repos/caddyserver/caddy/releases/latest?v=$RANDOM"
  caddy_latest_ver="$(curl -s $caddy_repos_url | grep 'tag_name' | cut -d\" -f4)" # awk -F \" '{print $4}'
  caddy_latest_ver_num=$(echo $caddy_ver | sed 's/v//')

	caddy_tmp="/tmp/install_caddy/"
	caddy_tmp_file="/tmp/install_caddy/caddy.tar.gz"
	[[ -d $caddy_tmp ]] && rm -rf $caddy_tmp
	if [[ ! ${caddy_arch} ]]; then
		echo -e "$red 获取 Caddy 下载参数失败！$none" && exit 1
	fi
	# local caddy_download_link="https://github.com/caddyserver/caddy/releases/download/v2.6.2/caddy_2.6.2_linux_${caddy_arch}.tar.gz"
	local caddy_download_link="https://github.com/caddyserver/caddy/releases/download/${caddy_latest_ver}/caddy_${caddy_latest_ver_num}_linux_${caddy_arch}.tar.gz"
	mkdir -p $caddy_tmp

	if ! wget --no-check-certificate -O "$caddy_tmp_file" $caddy_download_link; then
		echo -e "$red 下载 Caddy 失败！$none" && exit 1
	fi

	tar zxf $caddy_tmp_file -C $caddy_tmp
	cp -f ${caddy_tmp}caddy /usr/local/bin/

	if [[ ! -f /usr/local/bin/caddy ]]; then
		echo -e "$red 安装 Caddy 出错！$none" && exit 1
	fi
}

_install_caddy_service() {
	if [[ $systemd ]]; then
		cat >/lib/systemd/system/caddy.service <<-EOF
#https://github.com/caddyserver/dist/blob/master/init/caddy.service
[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
User=root
Group=root
ExecStart=/usr/local/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/local/bin/caddy reload --config /etc/caddy/Caddyfile
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
#AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
		EOF
		systemctl enable caddy
	else
		cp -f ${caddy_tmp}init/linux-sysvinit/caddy /etc/init.d/caddy
		sed -i "s/www-data/root/g" /etc/init.d/caddy
		chmod +x /etc/init.d/caddy
		update-rc.d -f caddy defaults
	fi

	# ref https://github.com/caddyserver/caddy/tree/master/dist/init/linux-systemd
	mkdir -p /etc/caddy
	mkdir -p /etc/ssl/caddy
	mkdir -p /etc/caddy/sites
}


_update_caddy_version() {
	_get_latest_version
	if [[ $caddy_ver != $caddy_latest_ver ]]; then
		echo
		echo -e " $green 咦...发现新版本耶....正在拼命更新.......$none"
		echo
		_download_v2ray_file
		do_service restart v2ray
		echo
		echo -e " $green 更新成功啦...当前 Caddy 版本: ${cyan}${caddy_latest_ver}$none"
		echo
		echo -e " $yellow 温馨提示: 为了避免出现莫名其妙的问题...V2Ray 客户端的版本最好和服务器的版本保持一致$none"
		echo
	else
		echo
		echo -e " $green 木有发现新版本....$none"
		echo
	fi
}