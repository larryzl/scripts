#!/bin/bash
#set -e
#
# Desc: CentOS zsh 一键安装脚本
# CreateDate: 2019-03-08 17:56:49
# LastModify:
# Author: larry
#
# History:
#
#
# ---------------------- Script Begin ----------------------
#

#- 查看当前shell
echo "当前 shell 为:  $SHELL"

#- 安装zsh
echo "正在安装 zsh"
yum -y install git wget zsh

#- 设置默认shell
echo "正在设置默认shell"
chsh -s /bin/zsh

#- 安装oh-my-zsh（自动）
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 修改主题
sed -i 's/ZSH_THEME=.*$/ZSH_THEME="ys"/g' ~/.zshrc
sed -i 's/^plugins=.*$/plugins=(git autojump zsh-completions systemd yum wd common-aliases git-flow grails rvm history-substring-search github gradle svn node npm zsh-syntax-h ighlighting sublime)/g' ~/.zshrc

source ~/.zshrc
