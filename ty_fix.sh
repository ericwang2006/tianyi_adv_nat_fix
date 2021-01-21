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

main() {
	action="$1"
	case "${action}" in
	hotfix)
		hotfix
		;;
	rollback)
		rollback
		;;
	*) ;;

	esac
}

main "$@"
