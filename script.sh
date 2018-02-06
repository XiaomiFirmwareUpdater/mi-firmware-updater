#!/bin/bash
echo Exporting variables:
miuidate=$(curl -s http://en.miui.com/forum.php | grep http://en.miui.com/download.html | grep -o '[0-9]*[.][0-9]*[.][0-9]*') && echo "Latest miui update is $miuidate"
site=http://bigota.d.miui.com/$miuidate/
echo Fetching updates:
while read device; do
id=$(echo $device | cut -d , -f1)
name=$(echo $device | cut -d , -f2)
{
echo Device: $(cut -d _ -f1 <<< $name) ; echo id: $id
curl -s http://en.miui.com/download-$id.html | grep miui_$name$miuidate | cut -d '"' -f6 | cut -d '"' -f1
} >> data
done <devices
cat data | grep -E "(http|https)://[a-zA-Z0-9./?=-]*" > links
echo Downloading:
wget -qq --progress=bar https://github.com/xiaomi-firmware-updater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
roms=$(cat links | cut -d "/" -f5 | cut -d '"' -f1)
for link in $(echo $roms); do
wget -qq --progress=bar $site$link
./create_flashable_firmware.sh $link
rm $link; done
echo Uploading:
for file in *.zip; do wput $file ftp://$basketbuilduser:$basketbuildpass@basketbuild.com//Xiaomi-Firmware/Developer/$miuidate/ ; done
for file in *.zip; do wput $file ftp://$afhuser:$afhpass@uploads.androidfilehost.com//Xiaomi-Firmware/Developer/$miuidate/ ; done
