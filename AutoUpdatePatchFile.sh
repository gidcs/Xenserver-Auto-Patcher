#!/bin/bash
#
# AutoUpdatePatchFile for XenServer
# Powered by LKS
# http://www.guyusoftware.com/
#
# AutoUpdatePatchFile.sh


VER=$1
VER="${VER:-71}"
DIR=`pwd`
MaxCount=10
DATE=`date '+%Y-%m-%d'`
XMLFILEURL="http://updates.xensource.com/XenServer/updates.xml"
XMLFILE="$DIR/updates.xml"
PATCHFILE="$DIR/XenServer${VER}.patch"
SKIPFILE="$DIR/XenServer${VER}.skip"
OLDPATCHDIR="$DIR/old/${VER}"
OLDPATCHFILE="$OLDPATCHDIR/XenServer${VER}.patch.$DATE"
OLDPATCHTARDIR="$DIR/oldtar/${VER}"

function PreCheck {
	mkdir -p $OLDPATCHDIR
	mkdir -p $OLDPATCHTARDIR
	if [ ! -f $SKIPFILE ]; then
		touch $SKIPFILE
	fi
}

function DownloadXML {
	wget -O $XMLFILE $XMLFILEURL &> /dev/null
	if [ "$?" == "1" ]; then
		echo "[Error] Cannot download file from server."
		exit
	fi
}

function CreateBackupTarBall {
	count=`ls -Al $OLDPATCHDIR | grep -v "total" | wc -l`
	if [ $count -gt "$MaxCount" ]; then
		tar zcf $OLDPATCHTARDIR/$DATE.tar.gz $OLDPATCHDIR &> /dev/null
		rm -f $OLDPATCHDIR/*
	fi
}

function CreateBackup {
	if [ -f $PATCHFILE ]; then
		mv $PATCHFILE $OLDPATCHFILE
	fi
	touch $PATCHFILE
}


function CreatePatch {
	SKIP=`cat $SKIPFILE | awk '{ if($1!="") { print $1 }}' | awk '{ printf t $1 }{t="\\\|"}'`
	if [[ "$SKIP" != "" ]]; then
		cat $XMLFILE | grep XS${VER} | grep -v '<!--' | awk -F'url="' '{ print $2 }' | awk -F'"' '{ if($1!="") { print $1 }}' | grep -v $SKIP > $PATCHFILE
	else
		cat $XMLFILE | grep XS${VER} | grep -v '<!--' | awk -F'url="' '{ print $2 }' | awk -F'"' '{ if($1!="") { print $1 }}' > $PATCHFILE
	fi
	sed -i 's/&amp;/\&/g' $PATCHFILE
}

function RemoveXML {
	rm -f $XMLFILE
}


echo "[AutoUpdatePatchFile] Start updating your XenServer${VER}.patch..."

#start
PreCheck
CreateBackup
CreateBackupTarBall
while [[ ! -s $PATCHFILE ]]; do
	DownloadXML
	CreatePatch
	RemoveXML
done
echo "[AutoUpdatePatchFile] Your XenServer${VER}.patch is up-to-date now..."
