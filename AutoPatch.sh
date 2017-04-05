#!/bin/bash
#
# Apply Patch for XenServer
# Powered by LKS
# http://www.guyusoftware.com/
#
# AutoPatch.sh

URL="https://raw.githubusercontent.com/gidcs/Xenserver-Auto-Patcher/master"

VER=`cat /etc/redhat-release | awk '{ print $3 }' | awk -F'.' '{ print $1"."$2}'`
VER=`echo $VER | awk -F'.' '{ print $1$2}'`

function get {
	wget -c -O $1 $2 --no-check-certificate &> /dev/null	
	if [ "$?" == "1" ]; then
			echo "[Error] Cannot download file from server."
		exit
	fi
}

echo "[AutoPatch] Start patching your XenServer..."
get XenServer${VER}.patch $URL/XenServer${VER}.patch
get PatchXS.sh $URL/PatchXS.sh
chmod 755 PatchXS.sh
cat XenServer${VER}.patch | awk '{ system("./PatchXS.sh \""$1"\"")}'
rm -f XenServer${VER}.patch
rm -f PatchXS.sh
rm -f AutoPatch.sh
echo "[AutoPatch] Your XenServer is up-to-date now..."
