#!/bin/bash
#
# Apply Patch for XenServer
# Powered by LKS
# http://www.guyusoftware.com/
#
# PatchXS.sh


function get {
	wget -c -O $1 $2 --no-check-certificate &> /dev/null	
	if [ "$?" == "1" ]; then
			echo "[Error] Cannot download file from server."
		exit
	fi
}

# get host uuid
HOST_UUID=`xe host-list --minimal`

# get url from arguement
URL=$1

# parse filename and get 
FILE="XS"
FILE+=`echo $URL | awk -F'XS' '{ print $2 }'`
XSPATCH=`echo $FILE | awk -F'.zip' '{ print $1 }'`

# check if patched?
XSPATCH_UUID=`xe patch-list name-label="$XSPATCH" --minimal`
if [ "$XSPATCH_UUID" != "" ]; then
	echo "$XSPATCH"'('"$XSPATCH_UUID"') had already patched!'
	exit
fi

# download zipfile and unzip it
XSFILE=$XSPATCH".xsupdate"
get $FILE $URL
unzip $FILE
echo 'ZipFile: '"$FILE"
echo 'UpdateFile: '"$XSFILE"

# patch
PATCHUUID=`xe patch-upload file-name="$XSFILE"`
xe patch-apply host-uuid="$HOST_UUID" uuid="$PATCHUUID"
echo "$XSFILE"' has already patched!'

# remove all useless file
rm -rf XS*
