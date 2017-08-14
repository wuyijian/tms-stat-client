#!/bin/bash
#安装jdk安装包，需要root权限
#在/opt/taomee/下创建javatool目录
#解压jdk8,安装


# 创建javatool工具目录
mkdir -p /opt/taomee/javatool && echo "create jdktool  success" &&\

# 拷贝jdk工具
mv ./jdk-8u144-linux-x64.tar.gz /opt/taomee/javatool/ && echo "cp jdk success" &&\

# 解压并安装
cd /opt/taomee/javatool && tar xzvf ./jdk-8u144-linux-x64.tar.gz && rm -rf ./jdk-8u144-linux-x64.tar.gz && ln -s ./jdk1.8.0_144 jdk && echo "install success" &&\

# 删除jdk安装包
rm -rf /opt/taomee/stat/tms-stat-client/jdk-8u144-linux-x64.tar.gz
