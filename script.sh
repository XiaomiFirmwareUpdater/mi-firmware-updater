#!/bin/bash
# Export Variables
export romsite="http://bigota.d.miui.com"
extract="create_flashable_firmware.sh"
upload='curl --upload-file'
export miuidate=$(curl -s http://en.miui.com/forum.php | grep http://en.miui.com/download.html | cut -d ">" -f 3 | cut -d '<' -f 1 | tee) && echo "Latest miui update is $miuidate"

# Fetch Updates
echo "capricorn: Global"
capricorn_global=$(curl -s http://en.miui.com/download-314.html | grep $romsite"/"$miuidate"/"miui_MI5SGlobal_$miuidate_)
if [ "$capricorn_global" != "" ] ; then
export MI5SGlobal=$(echo $capricorn_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5SGlobal && echo Url= $romsite"/"$miuidate"/"$MI5SGlobal
fi
echo "capricorn: China"
capricorn_china=$(curl -s http://en.miui.com/download-314.html#456 | grep $romsite"/"$miuidate"/"miui_MI5S_$miuidate_)
if [ "$capricorn_china" != "" ] ; then
export MI5S=$(echo $capricorn_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5S && echo Url= $romsite"/"$miuidate"/"$MI5S
fi

# Downloading
wget -qq --progress=bar https://github.com/xiaomi-firmware-updater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
echo "Working on capricorn_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5SGlobal && ./$extract $MI5SGlobal && rm $MI5SGlobal
echo "Working on capricorn_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5S && ./$extract $MI5S && rm $MI5S

#Uploading
wput "{$(echo *.zip | tr ' ' ',')}" ftp://$afhuser:$afhpass@uploads.androidfilehost.com//mifirmware/$miuidate/
wput "{$(echo *.zip | tr ' ' ',')}" ftp://$basketbuilduser:$basketbuildpass@basketbuild.com//mifirmware/$miuidate/
