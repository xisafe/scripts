## from fabric.api import *
local    #执行本地命令，如local('uname -s')
lcd      #切换本地目录，如lcd('/home')
cd       #切换远程目录，如cd('/var/logs')
run      #执行远程命令，如run('free -m')
sudo     #sudo方式执行远程命令，如sudo('/etc/init.d/httpd start')
put      #上次本地文件导远程主机，如put('/home/user.info','/data/user.info')
get      #从远程主机下载文件到本地，如：get('/data/user.info','/home/user.info')
prompt   #获得用户输入信息，如：prompt('please input user password:')
reboot   #重启远程主机，如：reboot()
env      #环境变量
@task       #函数修饰符，标识的函数为 fab 可调用的，不标记的对 fab 不可见。
@runs_once  #函数修饰符，标识的函数只会执行一次，不受多台主机影响
@roles      #函数修饰符，配合 env.roledefs 的角色使用



## from fabric.colors import *
print blue(text)
print cyan(text)
print green(text)
print magenta(text)
print red(text)
print white(text)
print yellow(text)

## from fabric.contrib.console import confirm 
confirm  #获得提示信息确认，如：confirm('Test failed,Continue[Y/N]?')
