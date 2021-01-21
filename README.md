# 修复天邑路由器某些端口不能转发的问题

## 简介

TIANYI(天邑)路由器的端口转发存在bug，某些合法端口无法转发(比如60747)
原因就是判断端口是否合法的正则表达式存在错误，这个脚本采用hotfix的方式修复。

# 重要提示

- 本脚本仅用于测试和学习研究，禁止用于商业用途
- 本人不能保证其合法性，准确性，完整性和有效性
- 本人不承担使用此脚本带来的任何直接或者间接的损失
- 不提供任何形式的技术支持
- 请根据自己的承受能力选择是否使用

# 食用方法

1. 开启telnet
	`curl http://wifieasy.cn/getDiagResult.json?step=-1&action=utelnetd -l /bin/sh`
	或者直接用浏览器访问上面网址

2. 保证连接互联网，使用任意telnet客户端连接路由器，执行命令

	`curl -s -k https://cdn.jsdelivr.net/gh/ericwang2006/tianyi_adv_nat_fix/ty_fix.sh |sh -s hotfix`
3. 恢复
	直接重启路由器或者用telnet连接路由器，执行命令
	
	`curl -s -k https://cdn.jsdelivr.net/gh/ericwang2006/tianyi_adv_nat_fix/ty_fix.sh |sh -s rollback`

4. 已知问题
	目前仅在TY300路由器新web界面固件下测试过，其它固件或者其他型号机型没有测试过。
