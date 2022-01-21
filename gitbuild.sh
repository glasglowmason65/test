#!/bin/bash
:<<EOF
监视新的提交，自定执行build脚本
EOF
# set -e
REPOSITORY_DIR="./"
build() {
    ##
    ## 构建并运行
    ##
    # 1: # build 开发java mtproxy（在开发阶段，已经运行了服务当重新编译是，会触发spring dev tool 自动重启应用。）
    # (cd java_backend && ./gradlew mtproxy:build -x test)
    # 2: 
    docker-compose build
    docker-compose up -d
    docker-compose push
    sudo docker system prune -f
    
    # (cd java_backend && ./gradlew mtproxy:build)
}

watch_git() {
    git fetch origin
    CHANGED=$(git branch -v | grep -q '\[behind')$?
    if [[ $CHANGED -eq 0 ]]; then
        echo "检测到有新的提交，开始build"
        git pull
        build
    fi
}

while :
do
	echo "watch git remote changed, Press [CTRL+C] to stop.."
    watch_git
	sleep 5
done

# while true
# do
#     echo "==="
#     watch_git
# done