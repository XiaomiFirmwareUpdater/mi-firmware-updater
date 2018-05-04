#!/bin/bash
function getmiuidate() {
y=$(date '+%y' | cut -c2); month=$(date '+%m');
tmpday=$(date '+%u')
if [ $tmpday  == 4 ] ; then
day=$(date '+%d');
else
day=$(date -dlast-thursday '+%d');
fi
checkmonth=$(echo $month | cut -c1);
if [ $checkmonth  == 0 ] ; then
m=$(echo $month | cut -c2)
else
m=$month
fi
checkday=$(echo $day | cut -c1);
if [ $checkday  == 0 ] ; then
d=$(echo $day | cut -c2)
else
d=$day
fi
today=$(echo $y.$m.$d)
}

function datecheck() {
checker=$(curl -s http://en.miui.com/download-$id.html | grep -o '[0-9]*[.][0-9]*[.][0-9]*' | grep $today)
if [ "$today" == "$checker" ]; then
miuidate=$today && echo "Latest miui update is $miuidate"
else
echo "Can't find updates!" ; exit
fi
miuiversion=$(cat miuiversion | head -n1)
if [ "$miuidate" == "$miuiversion" ]; then
echo "No new updates!" ; exit
else
sed -i "1i $miuidate" miuiversion
fi
}

function fetch() {
echo Fetching updates:
cat device | while read device; do
id=$(echo $device | cut -d , -f1)
name=$(echo $device | cut -d , -f2)
datecheck
curl -s http://en.miui.com/download-$id.html | grep 'margin-top: 0' | grep miui_$name$miuidate | cut -d '"' -f6 >> data
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
md5sum *.zip > changelog/$miuidate/$miuidate.md5
find . -type f -size 0k -delete
}

function upload() {
mkdir -p ~/.ssh  &&  echo "Host *" > ~/.ssh/config && echo " StrictHostKeyChecking no" >> ~/.ssh/config
echo Uploading Files:
for file in *.zip; do product=$(echo $file | cut -d _ -f2); sshpass -p $sfpass rsync -avP -e ssh $file yshalsager@web.sourceforge.net:/home/frs/project/xiaomi-firmware-updater/Developer/$miuidate/$product/ ; done
for file in *.zip; do product=$(echo $file | cut -d _ -f2); wput $file ftp://$afhuser:$afhpass@uploads.androidfilehost.com//Xiaomi-Firmware/Developer/$miuidate/$product/ ; done
}

function push() {
echo Pushing:
git config --global user.email "$gitmail" ; git config --global user.name "$gituser"
git add miuiversion changelog/ ; git commit -m "$miuidate"
git push -q https://$GIT_OAUTH_TOKEN_XFU@github.com/XiaomiFirmwareUpdater/$repo.git $branch
}

# Start
getmiuidate
fetch
mkdir -p changelog/$miuidate/
download_extract
upload
push
