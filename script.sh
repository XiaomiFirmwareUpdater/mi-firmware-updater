#!/bin/bash

check_db () {
#Check if db exist
if [ -e miuiversion ]
then
    mv miuiversion miuiversion_old
else
    echo "DB not found!"
fi
}

get_script () {
#Download
curl -H "PRIVATE-TOKEN: $GITLAB_OAUTH_TOKEN_VE" 'https://gitlab.com/api/v4/projects/7746867/repository/files/getversion.sh/raw?ref=master' -o getversion.sh && chmod +x getversion.sh
}

fetch_updates () {
#Fetch
echo Fetching updates:
cat device | while read device; do
codename=$(echo $device | cut -d , -f1)
android=$(echo $device | cut -d , -f2)
id=$(echo $device | cut -d , -f3)
tmpname=$(echo $device | cut -d , -f1 | sed 's/_/-/g')
url=`./getversion.sh $codename X $android`
echo $tmpname"="$url >> raw_out
sed -i 's/param error/not avilable/g' ./raw_out
done
cat raw_out | sort | sed 's/http.*miui_//' | cut -d _ -f1,2 | sed 's/-/_/g' > miuiversion
}

compare () {
#Compare
echo Comparing:
cat miuiversion | while read rom; do
	codename=$(echo $rom | cut -d = -f1)
	new=`cat miuiversion | grep $codename | cut -d = -f2`
	old=`cat miuiversion_old | grep $codename | cut -d = -f2`
	diff <(echo "$old") <(echo "$new") | grep ^"<\|>" >> compare
done
awk '!seen[$0]++' compare > changes
}

check_changes () {
#Info
if [ -s changes ]
then
	echo "Here's the new updates!"
	cat changes | grep ">" | cut -d ">" -f2 | sed 's/ //g' 2>&1 | tee updates
else
    echo "No changes found!"
fi
}

get_links () {
#Downloads
if [ -s updates ]
then
    echo "Download Links!"
	for rom in `cat updates`; do cat raw_out | grep $rom | cut -d = -f2; done 2>&1 | tee dl_links
else
    echo "No new updates!"
fi
}

check_exist () {
#Check if this is a rolled out update
cat updates | while read update; do
git grep -q "$update" $(git rev-list --all) -- miuiversion
if [[ $? == 0 ]]
then
    echo "$update" - "This update is already uploaded, no need to work again!"; old=$update
    sed -i "/$old/d" ./dl_links
else
    echo "$update" - "Seems this is a new update."
fi
done
}

main () {
#Start

wget -qq --progress=bar https://github.com/XiaomiFirmwareUpdater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
cat dl_links | while read link; do
dl=$(echo $link | cut -d = -f2)
zip=$(echo $dl | cut -d / -f5)
ver=$(echo $zip | cut -d _ -f3)
echo Downloading $zip
aria2c -x16 -q $dl
mkdir -p changelog/$ver/
./create_flashable_firmware.sh $zip
rm $zip; done
}

generate_diff () {
#Diff
for file in *.zip; do version=$(echo $file | cut -d _ -f5)
if [[ $file =~ ^[a-z]*_[a-z]*_[a-z]*_[A-Z0-9]*_V[0-9]*.[0-9]*.[0-9]*.[0-9]*.[A-Z][A-Z][A-Z]MI[A-Z][A-Z]_[a-z0-9]*_[0-9]*.[0-9]*.[a-z]*$ ]]; then
    echo "Generating diff from global rom zip"
    oldversion=$(ls changelog/ | sort | grep MI | head -n2 | tail -n1)
elif [[ $file =~ ^[a-z]*_[a-z]*_[a-z]*_[A-Z0-9]*_V[0-9]*.[0-9]*.[0-9]*.[0-9]*.[A-Z][A-Z][A-Z]CN[A-Z][A-Z]_[a-z0-9]*_[0-9]*.[0-9]*.[a-z]*$ ]]; then
    echo "Generating diff from chinese rom zip"
    oldversion=$(ls changelog/ | sort | grep CN | head -n2 | tail -n1)
else
    echo "Generating diff from weekly rom zip"
    oldversion=$(ls changelog/ | sort | head -n2 | tail -n1)
fi
diff changelog/$oldversion/*.log changelog/$version/*.log > changelog/$version/$oldversion-$version.diff
done
}

upload () {
#Upload
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
}

push () {
#Push
echo Pushing:
git add miuiversion changelog/ ; git -c "user.name=$gituser" -c "user.email=$gitmail" commit -m "Sync: $(date +%d.%m.%Y)"
export GIT_TAG=$branch-$(date +%d.%m.%Y)
github-release release -u XiaomiFirmwareUpdater -r $repo -t $GIT_TAG -n "$GIT_TAG" -d "Sync: $(date +%d.%m.%Y), upload firmware from $(cat updates | tr '\n' '&') MIUI ROM"
git push -q https://$GIT_OAUTH_TOKEN_XFU@github.com/XiaomiFirmwareUpdater/$repo.git HEAD:$branch
for file in *.zip; do name=$(echo $file); github-release upload -u XiaomiFirmwareUpdater -r $repo -t $GIT_TAG -n "$name" -f $name; done
}

telegram () {
#Telegram
wget -q https://github.com/yshalsager/telegram.sh/raw/master/telegram && chmod +x telegram
for file in *.zip; do 
	codename=$(echo $file | cut -d _ -f2)
	model=$(echo $file | cut -d _ -f4)
	version=$(echo $file | cut -d _ -f5)
	android=$(echo $file | cut -d _ -f7 | cut -d . -f1,2)
	size=$(du -h $file | awk '{print $1}')
	md5=$(md5sum $file | awk '{print $1}')
	./telegram -t $bottoken -c @XiaomiFirmwareUpdater -M "New weekly fimware update available!
	*Device*: $model
	*Codename*: $codename
	*Version*: $version
	*Android*: $android
	Filename: *$file*
	*Filesize*: $size
	*MD5*: $md5
	*Download Links*:
	[Sourceforge](https://sourceforge.net/projects/xiaomi-firmware-updater/files/Developer/$version/) - [Github](https://github.com/XiaomiFirmwareUpdater/firmware_xiaomi_$codename/releases/tag/$GIT_TAG)
	@XiaomiFirmwareUpdater | @MIUIUpdatesTracker"
done
}

clean () {
#Cleanup
rm raw_out compare changes updates dl_links 2> /dev/null
}

# run
check_db
get_script
compare
check_changes
get_links
check_exist
if [ -s dl_links ]
then
main
#generate_diff
upload
push
telegram
clean
else
    echo "Nothing found!" && exit 0
fi
