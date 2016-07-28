#!/bin/bash
#
# Apply Patch for XenServer
# Powered by LKS
# http://www.guyusoftware.com/
#
# AutoPatch.sh

URL="https://raw.githubusercontent.com/gidcs/Xenserver-Auto-Patcher/master"

VER=`cat /etc/redhat-release | awk '{ print $3 }' | awk -F'.' '{ print $1"."$2}'`
if [ "$VER" == "7.0" ]; then
	VER="7"
else
	VER=`echo $VER | awk -F'.' '{ print $1$2}'`
fi

VER="${VER:-7}"

echo "[AutoPatch] Start patching your XenServer..."
wget -O XenServer${VER}.patch $URL/XenServer${VER}.patch &> /dev/null
if [ "$?" == "1" ]; then
	echo "[Error] Cannot download file from server."
	exit
fi
wget -O PatchXS.sh $URL/PatchXS.sh &> /dev/null
if [ "$?" == "1" ]; then
        echo "[Error] Cannot download file from server."
	exit
fi
chmod 755 PatchXS.sh
cat XenServer${VER}.patch | awk '{ system("./PatchXS.sh "$1)}'
rm -f XenServer${VER}.patch
rm -f PatchXS.sh
rm -f AutoPatch.sh
echo "[AutoPatch] Your XenServer is up-to-date now..."
