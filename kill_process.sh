#!/bin/bash
# @Author: haodaquan
# @Date:   2017-06-29 17:44:45
# @Last Modified by:   haodaquan
# @Last Modified time: 2017-06-29 17:44:45

process_tag=$1
arrproc=$(ps -ef | grep "${process_tag}" | grep -v grep | awk '{print $2}')
for p in $arrproc; do
        if [ "${p}"=~^[0-9]+$ ]; then
                kill -9 "${p}"
                echo `date "+%Y/%m/%d %H:%M:%S> "` ${p} " 进程已杀死！"  
        fi
done