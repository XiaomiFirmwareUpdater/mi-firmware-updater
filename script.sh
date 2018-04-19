#!/bin/bash
echo Exporting variables:
miuidate=$(curl -s http://en.miui.com/forum.php | grep http://en.miui.com/download.html | grep -o '[0-9]*[.][0-9]*[.][0-9]*') && echo "Latest miui update is $miuidate"
miuiversion=$(cat miuiversion | head -n1)
if [ "$miuidate" == "$miuiversion" ]; then
echo "No new updates!" ; exit
else
sed -i "1i $miuidate" miuiversion
fi
echo Fetching updates:
cat device | while read device; do
id=$(echo $device | cut -d , -f1)
name=$(echo $device | cut -d , -f2)
sp=$(echo $device | cut -d , -f3)
if [[ $name = *"Global"* ]]; then
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | cut -d '"' -f6 | head -n2 | tail -n1 >> data
elif [[ $sp = *"China"* ]]; then
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | cut -d '"' -f6 | tail -n1 >> data
elif [[ $sp = *"hydrogen_g"* ]]; then
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | cut -d '"' -f6 | head -n2 | tail -n1 >> data
elif [[ $sp = *"hydrogen_c"* ]]; then
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | cut -d '"' -f6 | head -n6 | tail -n1 >> data
elif [[ $sp = *"helium_g"* ]]; then
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | cut -d '"' -f6 | head -n4 | tail -n1 >> data
elif [[ $sp = *"helium_c"* ]]; then
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | cut -d '"' -f6 | head -n8 | tail -n1 >> data
else
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | cut -d '"' -f6 | tail -n1 >> data
fi
done
mkdir -p changelog/$miuidate/
wget -qq --progress=bar https://github.com/xiaomi-firmware-updater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
cat data | while read link; do
zip=$(echo $link | cut -d "/" -f5 | cut -d '"' -f1)
echo Downloading $zip
wget -qq --progress=bar $link
./create_flashable_firmware.sh $zip
rm $zip; done
md5sum *.zip > changelog/$miuidate/$miuidate.md5
find . -type f -size 0k -delete
echo Uploading Files:
for file in *.zip; do product=$(echo $file | cut -d _ -f2); wput $file ftp://$basketbuilduser:$basketbuildpass@basketbuild.com//Xiaomi-Firmware/Developer/$miuidate/$product/ ; done
for file in *.zip; do product=$(echo $file | cut -d _ -f2); wput $file ftp://$afhuser:$afhpass@uploads.androidfilehost.com//Xiaomi-Firmware/Developer/$miuidate/$product/ ; done
echo Pushing:
git config --global user.email "$gitmail" ; git config --global user.name "$gituser"
git add miuiversion changelog/ ; git commit -m "$miuidate"
git push -q https://$GIT_OAUTH_TOKEN_XFU@github.com/XiaomiFirmwareUpdater/$repo.git $branch
