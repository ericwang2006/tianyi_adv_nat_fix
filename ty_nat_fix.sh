#/bin/sh

# 修复天邑路由器某些端口不能转发的问题
# 本脚本仅用于测试和学习研究，禁止用于商业用途
# 本人不能保证其合法性，准确性，完整性和有效性
# 本人不承担使用此脚本带来的任何直接或者间接的损失

rollback() {
	mount | grep '/webs/ujs/router.js' >/dev/null
	if [ $? -eq 0 ]; then
		umount /webs/ujs/router.js
	fi
	dir="/tmp/routerjs"

	if [ -d "$dir" ]; then
		rm -rf $dir
	fi
}

hotfix() {
	rollback

	dir="/tmp/routerjs"
	mkdir $dir
	cp /webs/ujs/router.js $dir/
	num=$(cat $dir/router.js | grep -n 'function CheckPort(port)' | cut -d ":" -f 1)
	num=$((num + 1))
	# 此行注释
	sed -i "$num {s/^/\/\//}" $dir/router.js
	# 正确的端口号正则表达式
	sed -i "$num avar reg =/^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$/\r" $dir/router.js
	num=$((num + 1))
	# 插入tab
	sed -i "$num {s/^/\t/}" $dir/router.js
	echo 'download busybox-armv7l...'
	curl -k -o $dir/busybox-armv7l https://cdn.jsdelivr.net/gh/ericwang2006/tianyi_adv_nat_fix/busybox-armv7l && chmod +x $dir/busybox-armv7l
	if [ $? -eq 0 ]; then
		$dir/busybox-armv7l mount --bind $dir/router.js /webs/ujs/router.js
		echo 'fix sucess'
	else
		echo 'download busybox-armv7l fail'
	fi
}

#适用老版本固件
rollback_old() {
	mount | grep '/webs/scvrt.htm' >/dev/null
	if [ $? -eq 0 ]; then
		umount /webs/scvrt.htm
	fi
	dir="/tmp/routerjs"

	if [ -d "$dir" ]; then
		rm -rf $dir
	fi
}

#适用老版本固件
hotfix_old() {
	rollback_old
	dir="/tmp/routerjs"
	bb=$dir/busybox-armv7l

	mkdir $dir
	echo 'download busybox-armv7l...'
	#这里自建一个http服务器或者自己想其他办法吧
	wget -O $bb http://192.168.0.2/busybox-armv7l && chmod +x $dir/busybox-armv7l
	if [ $? -ne 0 ]; then
		echo 'download busybox-armv7l fail'
		exit 1
	fi

	cp /webs/scvrt.htm $dir/
	num=$(cat $dir/scvrt.htm | grep -n 'function CheckPort(port)' | cut -d ":" -f 1)
	num=$((num + 1))
	# 此行注释
	$bb sed -i "$num {s/^/\/\//}" $dir/scvrt.htm
	# 正确的端口号正则表达式
	$bb sed -i "$num avar reg =/^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$/\r" $dir/scvrt.htm
	num=$((num + 1))
	# 插入tab
	$bb sed -i "$num {s/^/\t/}" $dir/scvrt.htm
	$bb mount --bind $dir/scvrt.htm /webs/scvrt.htm
	echo 'fix sucess'
}

main() {
	action="$1"
	case "${action}" in
	hotfix)
		hotfix
		;;
	rollback)
		rollback
		;;
	hotfix_old)
		hotfix_old
		;;
	rollback_old)
		rollback_old
		;;
	*) ;;

	esac
}

main "$@"
