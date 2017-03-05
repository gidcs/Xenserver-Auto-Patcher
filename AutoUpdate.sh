#!/bin/bash
#
# AutoUpdateAllPatch for XenServer
# Powered by LKS
# http://www.guyusoftware.com/
#
# AutoUpdate.sh

./AutoUpdatePatchFile.sh 56
./AutoUpdatePatchFile.sh 62
./AutoUpdatePatchFile.sh 65
./AutoUpdatePatchFile.sh 70
git add .                                             
git commit -m "update patch url"
git push
