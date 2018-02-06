#!/bin/bash
echo Exporting variables:
miuiver="V$(curl -s http://en.miui.com/download.html | grep version | grep -o 'MIUI[0-9]*' | cut -c 5 | awk 'NR==2')" && echo "Latest miui update is $miuiver"

site=http://bigota.d.miui.com/$miuiver/
echo Fetching updates:
while read device; do
id=$(echo $device | cut -d , -f1)
name=$(echo $device | cut -d , -f2)
{
echo Device: $(cut -d _ -f1 <<< $name) ; echo id: $id
curl -s http://en.miui.com/download-$id.html | grep miui_$name$miuiver | cut -d '"' -f 6 | head -n1
} >> data
done <devices
cat data | grep -E "(http|https)://[a-zA-Z0-9./?=-]*" > links
echo Downloading:
wget -qq --progress=bar https://github.com/xiaomi-firmware-updater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
roms=$(cat links)
for link in $(echo $roms); do
wget -qq --progress=bar $link
file=$(echo $link | cut -d "/" -f5 | cut -d '"' -f1)
./create_flashable_firmware.sh $file
rm $file; done

#Uploading
for file in *.zip; do wput $file ftp://$basketbuilduser:$basketbuildpass@basketbuild.com//Xiaomi-Firmware/Stable/$miuiver/ ; done
for file in *.zip; do wput $file ftp://$afhuser:$afhpass@uploads.androidfilehost.com//Xiaomi-Firmware/Stable/$miuiver/ ; done
