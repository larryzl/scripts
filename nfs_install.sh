#!/bin/bash
#
#
# nfs install script for centos7

usage() {
	echo "$0 [-d NFS-DIR-FULLPATH] [-i IP-ADDR-OR-IP-NET]

Generate Docker daemon options based on flannel env file
OPTIONS:
	
	-d	NFS export dir full path, ex: /data
	-i	Client IP addr or IP net, ex: 192.168.8.0/24 or 192.168.8.2
	-c  Client mode

Ex:

	Server Mode: $0 -d /data -i 192.168.8.0/24
	Client Mode: $0 -c -d /target_dir:/local_dir -i 192.168.8.3
	
" >&2

	exit 1
}

while getopts "d:i:hc" opt; do
	case $opt in

		d)
			dir=$OPTARG
			;;
		i)
			ipnet=$OPTARG
			;;
		c)
			is_client=true
			;;
		
		[\?h])
			usage
			;;
	esac
done


if [ "${is_client}0" == "0" ];then
	yum -y install nfs-utils rpcbind
	systemctl enable rpcbind.service
	systemctl restart rpcbind.service
	systemctl enable nfs.service  
	systemctl start nfs.service  
	mkdir -pv $dir

	cat >> /etc/exports <<EOF
${dir} ${ipnet}(rw,sync,no_root_squash)
EOF
	exportfs -rv
	showmount -e localhost
else 
	target_dir=$(echo $dir|awk -F ':' '{print $1}')
	local_dir=$(echo $dir|awk -F ':' '{print $2}')
	mkdir -pv local_dir 
	yum install nfs-utils rpcbind
	systemctl enable rpcbind.service
	systemctl restart rpcbind.service
	systemctl enable nfs.service  
	systemctl start nfs.service  
	showmount -e $ipnet  |grep $target_dir 
	if [ $? -eq 0 ];then
		echo 
		mount -t nfs ${ipnet}:${target_dir} ${local_dir} \
		&& echo >> /etc/fstab <<EOF
${ipnet}:${target_dir}   ${local_dir}   nfs nolock 0 0
EOF
	else
		echo "not found nfs export"
		exit 1
	fi

fi








