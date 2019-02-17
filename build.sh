#!/bin/bash
# @Author: Bee
# @Date:   2019-02-17 08:38:58
# @Last Modified by:   Bee
# @Last Modified time: 2019-02-17 08:38:58

version=$1

command -v tar >/dev/null 2>&1 || { echo >&2 "请检查tar是否已安装!"; exit 1; }
command -v go >/dev/null 2>&1 || { echo >&2 "请检查golang是否已安装或环境变量是否正确!"; exit 1; }

if [[ ! -n "$version" ]];then
    echo "请执行如:"
    echo "$0 1.0.0"
    exit 1
fi

if [[ ! -d "build" ]];then
    mkdir build
fi

go build -o PPGo_Job

cp -r -p PPGo_Job build/PPGo_Job
cp -r -p run.sh build/run.sh
cp -r -p conf build/conf
cp -r -p static build/static
cp -r -p views build/views
rm -rf build/static/imgs

cd build && tar zcvf ../PPGo_Job-$version.tar.gz .

rm -rf ../build