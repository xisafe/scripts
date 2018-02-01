

curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


cat > /dev/null <<EOF
YAML
## YAML文件格式及编写注意事项
YAML是一种标记语言很直观的数据序列化格式，可读性高。类似于XML数据描述语言，语法比XML简单的很多。
YAML数据结构通过缩进来表示，连续的项目通过减号来表示，键值对用冒号分隔，数组用中括号括起来，hash用花括号括起来。
YAML文件格式注意事项：
1.不支持制表符tab键缩进，需要使用空格缩进
2.通常开头缩进2个空格
3.字符后缩进1个空格，如冒号、逗号、横杆
4.用井号注释
5.如果包含特殊字符用单引号引起来
6.布尔值（true、false、yes、no、on、off）必须用引号括起来，这样分析器会将他们解释为字符串
EOF