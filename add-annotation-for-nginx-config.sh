#!/bin/bash
#@author super lollipop
#@date   2020.07.14
#@usage  annotate nginx config

NGINX_HOME=/opt/nginx                           #nginx的安装目录
TARGET_DIR=/conf.d                              #需要修改的nginx配置目录
CROSS_LINE=5                                    #跨越行数为5，如第1行为关键字行，那么1，2，3，，4，5行都会被添加上“#”字符

grep_results=$(grep -rn \$cookie_token ${NGINX_HOME}${TARGET_DIR}/*) #grep找出包含字符串“$cookie_token”的文件

origin_IFS=$IFS   #internal field separator,内部字段分隔符，默认为空格
IFS=$'\n'         #修改为回车符

for result in ${grep_results}; do
#  echo $result  #result is like "/opt/nginx/conf.d/ios4.conf:17:  set $cookie_token '';"
  match_file=$(echo ${result} | awk -F ":" '{print $1}')     #提取出文件路径句柄
  key_start_line=$(echo ${result} | awk -F ":" '{print $2}') #提取关键字的行号
  end_line=$(expr ${key_start_line} + ${CROSS_LINE})           #计算出结束的行号
  echo ${match_file} ${key_start_line} ${end_line}               #打印匹配文件，开始行，结束行
  sed -i "${key_start_line},${end_line}s/^/#/" ${match_file} #执行在首行插入字符“#”
done

IFS=${origin_IFS} #改回原来的内部字段分隔符
