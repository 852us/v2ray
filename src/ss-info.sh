[[ -z $ip ]] && get_ip
if [[ $shadowsocks ]]; then
	local ss="ss://$(echo -n "${ssciphers}:${sspass}@${ip}:${ssport}" | base64 -w 0)#ss_${ip}"
	echo
	echo "---------- Shadowsocks 配置信息 -------------"
	echo
	echo -e "${yellow} 服务器地址 = ${cyan}${ip}${plain}"
	echo
	echo -e "${yellow} 服务器端口 = ${cyan}$ssport${plain}"
	echo
	echo -e "${yellow} 密码 = ${cyan}$sspass${plain}"
	echo
	echo -e "${yellow} 加密协议 = ${cyan}${ssciphers}${plain}"
	echo
	echo -e "${yellow} SS 链接 = ${cyan}$ss${plain}"
	echo
	echo -e " 备注: ${red} Shadowsocks Win 4.0.6 ${plain} 客户端可能无法识别该 SS 链接"
	echo
	echo -e "提示: 输入 ${cyan} v2ray ssqr ${plain} 可生成 Shadowsocks 二维码链接"
	echo
	echo -e "${yellow}免被墙..推荐使用JMS: ${cyan}https://getjms.com${plain}"
	echo
fi
