#!/bin/bash
#
# Apply Skip for Patch
# Powered by LKS
# http://www.guyusoftware.com/
#
# AutoSkip.sh

if [ $# != 3 ]; then
    echo "Usage:"
    echo "  $0 <skip_file> <old_patch> <new_patch>"
    exit 1
fi

SKIP_FILE=$1
OLD_PATCH=$2
NEW_PATCH=$3

echo "[AutoSkip] Start modifying skipfile..."
sed 's/'${OLD_PATCH}'/'${NEW_PATCH}'/g' ${SKIP_FILE} > ${SKIP_FILE}.new
echo "${OLD_PATCH} in ${NEW_PATCH}" >> ${SKIP_FILE}.new
diff ${SKIP_FILE} ${SKIP_FILE}.new
read -p "Overwrite the old file? (y/n): " ans
if [ "${ans}" == 'y' ] || [ "${ans}" == 'Y' ]; then
    mv ${SKIP_FILE}.new ${SKIP_FILE}
fi
echo "[AutoSkip] Done."
