@ECHO OFF
ECHO =================================
ECHO     自动拨号中
ECHO =================================
rasdial USA admin vpnpass
ECHO =================================
ECHO     拨号成功
ECHO =================================

:: for /f "tokens=4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (set ip=%%a)
:: route add 192.168.1.0 mask 255.0.0.0  %ip% 
:: 指定192.168.1.0的内部网段不走vpn路由

PAUSE