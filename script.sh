#!/bin/bash
function brake() {
if [ "$latest" == "true" ] || [ "$noupdates" == "true" ]; then set -e; fi
}
echo Getting latest verison:
tmpdevice=`cat device | cut -d , -f1 | head -n1`
tmpandroid=`cat device | cut -d , -f2 | head -n1`
miuidate=`./getversion.sh $tmpdevice X $tmpandroid | grep -o '[0-9]*[.][0-9]*[.][0-9]*' | head -n1`

echo Fetching updates:
cat device | while read device; do
codename=$(echo $device | cut -d , -f1)
android=$(echo $device | cut -d , -f2)
id=$(echo $device | cut -d , -f3)
url=`./getversion.sh $codename X $android`

miuiversion=$(cat miuiversion | head -n1)
if [ "$miuidate" == "$miuiversion" ]; then
echo "No new updates!" ; exit 1
export latest=true
brake
else
sed -i "1i $miuidate" miuiversion ; set +e
fi
echo $url >> data
sed -i 's/param error//g' ./miuiversion ./data && sed -i '/^\s*$/d' ./miuiversion ./data
done ; brake

wget -qq --progress=bar https://github.com/XiaomiFirmwareUpdater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
cat data | while read link; do
zip=$(echo $link | cut -d / -f5)
echo Downloading $zip
wget -qq --progress=bar $link
./create_flashable_firmware.sh $zip
rm $zip; done
md5sum *.zip > changelog/$miuidate/$miuidate.md5
find . -type f -size 0k -delete
brake

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
#for file in *.zip; do product=$(echo $file | cut -d _ -f2); version=$(echo $file | cut -d _ -f5); wput $file ftp://$basketbuilduser:$basketbuildpass@basketbuild.com//Xiaomi-Firmware/Developer/$version/$product/ ; done

echo Pushing:
git config --global user.email "$gitmail" ; git config --global user.name "$gituser"
brake && git add miuiversion changelog/ ; git commit -m "$miuidate"
git push -q https://$GIT_OAUTH_TOKEN_XFU@github.com/XiaomiFirmwareUpdater/$repo.git $branch
