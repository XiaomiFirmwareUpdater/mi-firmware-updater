#!/bin/bash
# Export Variables
export romsite="http://bigota.d.miui.com"
extract="create_flashable_firmware.sh"
upload='curl --upload-file'
export miuidate=8.1.4

# Fetch Updates
echo "aqua: China"
aqua_china=$(curl -s http://en.miui.com/download-300.html | grep $romsite"/"$miuidate"/"miui_MI4s_$miuidate_)
if [ "$aqua_china" != "" ] ; then
export MI4s=$(echo $aqua_china | cut -d "/" -f 10 | cut -d '"' -f 1 | tee )
echo File Name= $MI4s && echo Url= $romsite"/"$miuidate"/"$MI4s
fi

# Downloading
wget -qq --progress=bar https://github.com/xiaomi-firmware-updater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
echo "Working on aqua_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI4s && ./$extract $MI4s && rm $MI4s


#Uploading
wput "{$(echo *.zip | tr ' ' ',')}" ftp://$afhuser:$afhpass@uploads.androidfilehost.com//mifirmware/$miuidate/
wput "{$(echo *.zip | tr ' ' ',')}" ftp://$basketbuilduser:$basketbuildpass@basketbuild.com//mifirmware/$miuidate/
