#!/bin/bash
function getmiuiversion() {
echo Exporting variables:
miuiver="V$(curl -s http://en.miui.com/download.html | grep version | grep -o 'MIUI[0-9]*' | cut -c 5 | awk 'NR==2')" && echo "Latest miui update is $miuiver"
}

function fetch() {
echo Fetching updates:
cat device | while read device; do
id=$(echo $device | cut -d , -f1)
name=$(echo $device | cut -d , -f2)
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | grep miui_$name$miuiver | cut -d '"' -f6 | head -n1 >> data
done
}

function download_extract() {
wget -qq --progress=bar https://github.com/xiaomi-firmware-updater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
cat data | while read link; do
zip=$(echo $link | cut -d "/" -f5 | cut -d '"' -f1)
echo Downloading $zip
wget -qq --progress=bar $link
./create_flashable_firmware.sh $zip
rm $zip; done
}

function upload() {
mkdir -p ~/.ssh  &&  echo "Host *" > ~/.ssh/config && echo " StrictHostKeyChecking no" >> ~/.ssh/config
echo Uploading Files:
for file in *.zip; do product=$(echo $file | cut -d _ -f2); sshpass -p $sfpass rsync -avP -e ssh $file yshalsager@web.sourceforge.net:/home/frs/project/xiaomi-firmware-updater/Stable/$miuiver/$product/ ; done
for file in *.zip; do product=$(echo $file | cut -d _ -f2); wput $file ftp://$afhuser:$afhpass@uploads.androidfilehost.com//Xiaomi-Firmware/Stable/$miuiver/$product/ ; done
}

# Start
getmiuiversion
fetch
mkdir -p changelog/$miuidate/
download_extract
