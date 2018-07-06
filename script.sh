#!/bin/bash
echo Fetching updates:
cat device | while read device; do
codename=$(echo $device | cut -d , -f1)
android=$(echo $device | cut -d , -f2)
id=$(echo $device | cut -d , -f3)
url=`./getversion.sh $codename X $android`
echo $url >> data
sed -i 's/param error//g' ./data && sed -i '/^\s*$/d' ./data
done

wget -qq --progress=bar https://github.com/XiaomiFirmwareUpdater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
cat data | while read link; do
zip=$(echo $link | cut -d / -f5)
echo Downloading $zip
wget -qq --progress=bar $link
./create_flashable_firmware.sh $zip
rm $zip; done

echo Uploading Files:
mkdir -p ~/.ssh  &&  echo "Host *" > ~/.ssh/config && echo " StrictHostKeyChecking no" >> ~/.ssh/config
for file in *.zip; do product=$(echo $file | cut -d _ -f2); version=$(echo $file | cut -d _ -f5);
sshpass -p $sfpass sftp yshalsager,xiaomi-firmware-updater@web.sourceforge.net << EOF
cd /home/frs/project/xiaomi-firmware-updater/Developer/
mkdir $version
quit
EOF
sshpass -p $sfpass rsync -avP -e ssh $file yshalsager@web.sourceforge.net:/home/frs/project/xiaomi-firmware-updater/Developer/$version/$product/ ; done
for file in *.zip; do product=$(echo $file | cut -d _ -f2); version=$(echo $file | cut -d _ -f5); wput $file ftp://$afhuser:$afhpass@uploads.androidfilehost.com//Xiaomi-Firmware/Developer/$version/$product/ ; done
