#!/bin/bash
#@author super lollipop
#@date   2020-07-29
#@usage  fpmstatus?full output is not sorted, this script is use for getting the top 10 record sorted by "request cpu" field.
#http://127.0.0.1:8891/pmstatus?full

raw_output=$(curl -s http://127.0.0.1:8891/pmstatus?full)                     #使用curl访问得到输出结果，-s --silent
#echo "${raw_output}"
sorted_result=$(echo "${raw_output}" | LC_ALL=en_US.utf8 grep -nP "\d{2,}\.\d\d$" | sort -nrk 4)  #"LC_ALL=en_US.utf8"是设置grep程序的地区编码
#echo "${sorted_result}"
# sorted result :
# 1093:last request cpu:     192.42
# 1183:last request cpu:     183.89

IFS_old=$IFS #internal field separator,内部字段分隔符，默认为空格
IFS=$'\n'    #修改为回车符

i=0     #用作跳出循环的变量，第十次跳出循环
for row in ${sorted_result} ; do
  key_line=$(echo ${row} | awk -F ':' '{print $1}')     #提取关键行的行号数字
  #echo ${key_line}
  start_line=$(expr ${key_line} - 12)   #计算出需要提取的开始行
  end_line=$(expr ${key_line} + 1)      #计算出需要提取的结束行
  #echo ${start_line} ${key_line} ${end_line} #输出相关的行号查看
  echo "${raw_output}" | awk "NR==${start_line},NR==${end_line}"
  i=$(expr ${i} + 1)
  if [[ ${i} == 10 ]]; then     #如果i变量等于10，退出循环。
      break
  fi
done