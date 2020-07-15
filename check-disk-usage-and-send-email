#!/bin/bash
#@author super lollipop
#@date   2020-06-08
#@usage  check disk usage percentage and send email, you can add this script to crontab schedule.
#Notice: Please configure mail client. See "mail -v -s" command below.

email_address="superlollipop@163.com"   #定义通知邮箱地址变量，需要按需填写
date_stamp=$(date +"%Y-%M-%d %H:%M:%S") #定义时间变量

disks_usage_line=$(df -h | grep /dev/) #df -h查看磁盘空间信息，然后过滤相关的/dev/串行设备，可根据需要过滤

IFS_old=$IFS #internal field separator,内部字段分隔符，默认为空格
IFS=$'\n'    #修改为回车符

for disk_usage_line in ${disks_usage_line}; do
  disk_usage=$(echo "${disk_usage_line}" | awk -F " " '{print $5}' | cut -d "%" -f 1) #过滤得到一行的使用率数字
  #把一行磁盘驱动信息输入到awk命令进行处理，-F是--field-separator字段分隔符，以“ ”空格作为分隔符，提取第五列（占用率），
  #通过管道传给cut进行处理，-d是--delimiter分隔符“%”，-f是--field选择第一个，即文本90%会变成90
  disk_driver=$(echo "${disk_usage_line}" | awk -F " " '{print $1}') #过滤得到一行的驱动器文本
  if [[ "$disk_usage" -gt 90 ]]; then #如果大于90，执行邮件通知操作
    echo "${date_stamp} ${disk_driver}磁盘空间占用大于90%"
    echo "${disk_driver}磁盘空间占用大于90%" | mail -v -s "[磁盘空间不足]" $email_address
  else
    echo "${date_stamp} ${disk_driver} not greater than 90."
  fi
done

IFS=${IFS_old} #改回原来的内部字段分隔符
