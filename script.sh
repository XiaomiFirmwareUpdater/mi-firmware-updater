#!/bin/bash
# Export Variables
export romsite="http://bigota.d.miui.com"
transfer="https://transfer.sh"
extract="create_flashable_firmware.sh"
upload='curl --upload-file'
export miuidate=$(curl -s http://en.miui.com/forum.php | grep http://en.miui.com/download.html | cut -d ">" -f 3 | cut -d '<' -f 1 | tee) && echo "Latest miui update is $miuidate"

# Fetch Updates
echo "aqua: China"
aqua_china=$(curl -s http://en.miui.com/download-300.html | grep $romsite"/"$miuidate"/"miui_MI4s_$miuidate_)
if [ "$aqua_china" != "" ] ; then
export MI4s=$(echo $aqua_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI4s && echo Url= $romsite"/"$miuidate"/"$MI4s
fi
echo "cappu: China"
cappu_china=$(curl -s http://en.miui.com/download-325.html | grep $romsite"/"$miuidate"/"miui_MIPAD3_$miuidate_)
if [ "$cappu_china" != "" ] ; then
export MIPAD3=$(echo $cappu_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIPAD3 && echo Url= $romsite"/"$miuidate"/"$MIPAD3
fi
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
echo "chiron: Global"
chiron_global=$(curl -s http://en.miui.com/download-334.html | grep $romsite"/"$miuidate"/"miui_MIMIX2Global_$miuidate_)
if [ "$chiron_global" != "" ] ; then
export MIMIX2Global=$(echo $chiron_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMIX2Global && echo Url= $romsite"/"$miuidate"/"$MIMIX2Global
fi
echo "chiron: China"
chiron_china=$(curl -s http://en.miui.com/download-334.html#492 | grep $romsite"/"$miuidate"/"miui_MIMIX2_$miuidate_)
if [ "$chiron_china" != "" ] ; then
export MIMIX2=$(echo $chiron_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMIX2 && echo Url= $romsite"/"$miuidate"/"$MIMIX2
fi
echo "gemini: Global"
gemini_global=$(curl -s http://en.miui.com/download-299.html | grep $romsite"/"$miuidate"/"miui_MI5Global_$miuidate_)
if [ "$gemini_global" != "" ] ; then
export MI5Global=$(echo $gemini_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5Global && echo Url= $romsite"/"$miuidate"/"$MI5Global
fi
echo "gemini: China"
gemini_china=$(curl -s http://en.miui.com/download-299.html#435 | grep $romsite"/"$miuidate"/"miui_MI5_$miuidate_)
if [ "$gemini_china" != "" ] ; then
export MI5=$(echo $gemini_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5 && echo Url= $romsite"/"$miuidate"/"$MI5
fi
echo "helium: Global"
helium_global=$(curl -s http://en.miui.com/download-302.html#446 | grep $romsite"/"$miuidate"/"miui_MIMAX652Global_$miuidate_)
if [ "$helium_global" != "" ] ; then
export MIMAX652Global=$(echo $helium_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX652Global && echo Url= $romsite"/"$miuidate"/"$MIMAX652Global
fi
echo "helium: China"
helium_china=$(curl -s http://en.miui.com/download-302.html#458 | grep $romsite"/"$miuidate"/"miui_MIMAX652_$miuidate_)
if [ "$helium_china" != "" ] ; then
export MIMAX652=$(echo $helium_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX652 && echo Url= $romsite"/"$miuidate"/"$MIMAX652
fi
echo "hydrogen: Global"
hydrogen_global=$(curl -s http://en.miui.com/download-302.html#450 | grep $romsite"/"$miuidate"/"miui_MIMAXGlobal_$miuidate_)
if [ "$hydrogen_global" != "" ] ; then
export MIMAXGlobal=$(echo $hydrogen_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAXGlobal && echo Url= $romsite"/"$miuidate"/"$MIMAXGlobal
fi
echo "hydrogen: China"
hydrogen_china=$(curl -s http://en.miui.com/download-302.html#445 | grep $romsite"/"$miuidate"/"miui_MIMAX_$miuidate_)
if [ "$hydrogen_china" != "" ] ; then
export MIMAX=$(echo $hydrogen_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX && echo Url= $romsite"/"$miuidate"/"$MIMAX
fi
echo "ido: Global"
ido_global=$(curl -s http://en.miui.com/download-298.html | grep $romsite"/"$miuidate"/"miui_HM3Global_$miuidate_)
if [ "$ido_global" != "" ] ; then
export HM3Global=$(echo $ido_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM3Global && echo Url= $romsite"/"$miuidate"/"$HM3Global
fi
echo "ido: China"
ido_china=$(curl -s http://en.miui.com/download-298.html#433 | grep $romsite"/"$miuidate"/"miui_HM3_$miuidate_)
if [ "$ido_china" != "" ] ; then
export HM3=$(echo $ido_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM3 && echo Url= $romsite"/"$miuidate"/"$HM3
fi
echo "jason: China"
jason_china=$(curl -s http://en.miui.com/download-336.html#495 | grep $romsite"/"$miuidate"/"miui_MINote3_$miuidate_)
if [ "$jason_china" != "" ] ; then
export MINote3=$(echo $jason_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MINote3 && echo Url= $romsite"/"$miuidate"/"$MINote3
fi
echo "kenzo: Global"
kenzo_global=$(curl -s http://en.miui.com/download-301.html | grep $romsite"/"$miuidate"/"miui_HMNote3ProGlobal_$miuidate_)
if [ "$kenzo_global" != "" ] ; then
export HMNote3ProGlobal=$(echo $kenzo_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote3ProGlobal && echo Url= $romsite"/"$miuidate"/"$HMNote3ProGlobal
fi
echo "kenzo: China"
kenzo_china=$(curl -s http://en.miui.com/download-301.html#439 | grep $romsite"/"$miuidate"/"miui_HMNote3Pro_$miuidate_)
if [ "$kenzo_china" != "" ] ; then
export HMNote3Pro=$(echo $kenzo_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote3Pro && echo Url= $romsite"/"$miuidate"/"$HMNote3Pro
fi
echo "kate: Global"
kate_global=$(curl -s http://en.miui.com/download-301.html#449 | grep $romsite"/"$miuidate"/"miui_HMNote3ProtwGlobal_$miuidate_)
if [ "$kate_global" != "" ] ; then
export HMNote3ProtwGlobal=$(echo $kate_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote3ProtwGlobal && echo Url= $romsite"/"$miuidate"/"$HMNote3ProtwGlobal
fi
echo "land: Global"
land_global=$(curl -s http://en.miui.com/download-303.html | grep $romsite"/"$miuidate"/"miui_HM3SGlobal_$miuidate_)
if [ "$land_global" != "" ] ; then
export HM3SGlobal=$(echo $land_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM3SGlobal && echo Url= $romsite"/"$miuidate"/"$HM3SGlobal
fi
echo "land: China"
land_china=$(curl -s http://en.miui.com/download-303.html#447 | grep $romsite"/"$miuidate"/"miui_HM3S_$miuidate_)
if [ "$land_china" != "" ] ; then
export HM3S=$(echo $land_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM3S && echo Url= $romsite"/"$miuidate"/"$HM3S
fi
echo "libra: China"
libra_china=$(curl -s http://en.miui.com/download-293.html | grep $romsite"/"$miuidate"/"miui_MI4c_$miuidate_)
if [ "$libra_china" != "" ] ; then
export MI4c=$(echo $libra_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI4c && echo Url= $romsite"/"$miuidate"/"$MI4c
fi
echo "lithium: Global"
lithium_global=$(curl -s http://en.miui.com/download-317.html | grep $romsite"/"$miuidate"/"miui_MIMIXGlobal_$miuidate_)
if [ "$lithium_global" != "" ] ; then
export MIMIXGlobal=$(echo $lithium_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMIXGlobal && echo Url= $romsite"/"$miuidate"/"$MIMIXGlobal
fi
echo "lithium: China"
lithium_china=$(curl -s http://en.miui.com/download-317.html#460 | grep $romsite"/"$miuidate"/"miui_MIMIX_$miuidate_)
if [ "$lithium_china" != "" ] ; then
export MIMIX=$(echo $lithium_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMIX && echo Url= $romsite"/"$miuidate"/"$MIMIX
fi
echo "markw: China"
markw_china=$(curl -s http://en.miui.com/download-320.html#466 | grep $romsite"/"$miuidate"/"miui_HM4Pro_$miuidate_)
if [ "$markw_china" != "" ] ; then
export HM4Pro=$(echo $markw_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4Pro && echo Url= $romsite"/"$miuidate"/"$HM4Pro
fi
echo "mido: Global"
mido_global=$(curl -s http://en.miui.com/download-309.html#468 | grep $romsite"/"$miuidate"/"miui_HMNote4XGlobal_$miuidate_)
if [ "$mido_global" != "" ] ; then
export HMNote4XGlobal=$(echo $mido_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote4XGlobal && echo Url= $romsite"/"$miuidate"/"$HMNote4XGlobal
fi
echo "mido: China"
mido_china=$(curl -s http://en.miui.com/download-321.html#469 | grep $romsite"/"$miuidate"/"miui_HMNote4X_$miuidate_)
if [ "$mido_china" != "" ] ; then
export HMNote4X=$(echo $mido_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote4X && echo Url= $romsite"/"$miuidate"/"$HMNote4X
fi
echo "natrium: Global"
natrium_global=$(curl -s http://en.miui.com/download-315.html | grep $romsite"/"$miuidate"/"miui_MI5SPlusGlobal_$miuidate_)
if [ "$natrium_global" != "" ] ; then
export MI5SPlusGlobal=$(echo $natrium_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5SPlusGlobal && echo Url= $romsite"/"$miuidate"/"$MI5SPlusGlobal
fi
echo "natrium: China"
natrium_china=$(curl -s http://en.miui.com/download-315.html#457 | grep $romsite"/"$miuidate"/"miui_MI5SPlus_$miuidate_)
if [ "$natrium_china" != "" ] ; then
export MI5SPlus=$(echo $natrium_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5SPlus && echo Url= $romsite"/"$miuidate"/"$MI5SPlus
fi
echo "nikel: Global"
nikel_global=$(curl -s http://en.miui.com/download-309.html | grep $romsite"/"$miuidate"/"miui_HMNote4Global_$miuidate_)
if [ "$nikel_global" != "" ] ; then
export HMNote4Global=$(echo $nikel_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote4Global && echo Url= $romsite"/"$miuidate"/"$HMNote4Global
fi
echo "nikel: China"
nikel_china=$(curl -s http://en.miui.com/download-309.html#454 | grep $romsite"/"$miuidate"/"miui_HMNote4_$miuidate_)
if [ "$nikel_china" != "" ] ; then
export HMNote4=$(echo $nikel_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote4 && echo Url= $romsite"/"$miuidate"/"$HMNote4
fi
echo "omega: China"
omega_china=$(curl -s http://en.miui.com/download-304.html | grep $romsite"/"$miuidate"/"miui_HMPro_$miuidate_)
if [ "$omega_china" != "" ] ; then
export HMPro=$(echo $omega_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMPro && echo Url= $romsite"/"$miuidate"/"$HMPro
fi
echo "oxygen: Global"
oxygen_global=$(curl -s http://en.miui.com/download-328.html | grep $romsite"/"$miuidate"/"miui_MIMAX2Global_$miuidate_)
if [ "$oxygen_global" != "" ] ; then
export MIMAX2Global=$(echo $oxygen_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX2Global && echo Url= $romsite"/"$miuidate"/"$MIMAX2Global
fi
echo "oxygen: China"
oxygen_china=$(curl -s http://en.miui.com/download-328.html#482 | grep $romsite"/"$miuidate"/"miui_MIMAX2_$miuidate_)
if [ "$oxygen_china" != "" ] ; then
export MIMAX2=$(echo $oxygen_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX2 && echo Url= $romsite"/"$miuidate"/"$MIMAX2
fi
echo "prada: China"
prada_china=$(curl -s http://en.miui.com/download-318.html#461 | grep $romsite"/"$miuidate"/"miui_HM4_$miuidate_)
if [ "$prada_china" != "" ] ; then
export HM4=$(echo $prada_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4 && echo Url= $romsite"/"$miuidate"/"$HM4
fi
echo "riva: China"
riva_china=$(curl -s http://en.miui.com/download-338.html#499 | grep $romsite"/"$miuidate"/"miui_HM5A_$miuidate_)
if [ "$riva_china" != "" ] ; then
export HM5A=$(echo $riva_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM5A && echo Url= $romsite"/"$miuidate"/"$HM5A
fi
echo "rolex: Global"
rolex_global=$(curl -s http://en.miui.com/download-319.html | grep $romsite"/"$miuidate"/"miui_HM4AGlobal_$miuidate_)
if [ "$rolex_global" != "" ] ; then
export HM4AGlobal=$(echo $rolex_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4AGlobal && echo Url= $romsite"/"$miuidate"/"$HM4AGlobal
fi
echo "rolex: China"
rolex_china=$(curl -s http://en.miui.com/download-319.html#462 | grep $romsite"/"$miuidate"/"miui_HM4A_$miuidate_)
if [ "$rolex_china" != "" ] ; then
export HM4A=$(echo $rolex_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4A && echo Url= $romsite"/"$miuidate"/"$HM4A
fi
echo "rosy: China"
rosy_china=$(curl -s http://en.miui.com/download-340.html#505 | grep $romsite"/"$miuidate"/"miui_HM5_$miuidate_)
if [ "$rosy_china" != "" ] ; then
export HM5=$(echo $rosy_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM5 && echo Url= $romsite"/"$miuidate"/"$HM5
fi
echo "sagit: Global"
sagit_global=$(curl -s http://en.miui.com/download-326.html | grep $romsite"/"$miuidate"/"miui_MI6Global_$miuidate_)
if [ "$sagit_global" != "" ] ; then
export MI6Global=$(echo $sagit_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI6Global && echo Url= $romsite"/"$miuidate"/"$MI6Global
fi
echo "sagit: China"
sagit_china=$(curl -s http://en.miui.com/download-326.html#481 | grep $romsite"/"$miuidate"/"miui_MI6_$miuidate_)
if [ "$sagit_china" != "" ] ; then
export MI6=$(echo $sagit_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI6 && echo Url= $romsite"/"$miuidate"/"$MI6
fi
echo "santoni: Global"
santoni_global=$(curl -s http://en.miui.com/download-323.html | grep $romsite"/"$miuidate"/"miui_HM4XGlobal_$miuidate_)
if [ "$santoni_global" != "" ] ; then
export HM4XGlobal=$(echo $santoni_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4XGlobal && echo Url= $romsite"/"$miuidate"/"$HM4XGlobal
fi
echo "santoni: China"
santoni_china=$(curl -s http://en.miui.com/download-323.html#476 | grep $romsite"/"$miuidate"/"miui_HM4X_$miuidate_)
if [ "$santoni_china" != "" ] ; then
export HM4X=$(echo $santoni_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4X && echo Url= $romsite"/"$miuidate"/"$HM4X
fi
echo "scorpio: Global"
scorpio_global=$(curl -s http://en.miui.com/download-316.html | grep $romsite"/"$miuidate"/"miui_MINote2Global_$miuidate_)
if [ "$scorpio_global" != "" ] ; then
export MINote2Global=$(echo $scorpio_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MINote2Global && echo Url= $romsite"/"$miuidate"/"$MINote2Global
fi
echo "scorpio: China"
scorpio_china=$(curl -s http://en.miui.com/download-316.html#459 | grep $romsite"/"$miuidate"/"miui_MINote2_$miuidate_)
if [ "$scorpio_china" != "" ] ; then
export MINote2=$(echo $scorpio_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MINote2 && echo Url= $romsite"/"$miuidate"/"$MINote2
fi
echo "tiffany: China"
tiffany_china=$(curl -s http://en.miui.com/download-329.html | grep $romsite"/"$miuidate"/"miui_MI5X_$miuidate_)
if [ "$tiffany_china" != "" ] ; then
export MI5X=$(echo $tiffany_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5X && echo Url= $romsite"/"$miuidate"/"$MI5X
fi
echo "ugg: Global"
ugg_global=$(curl -s http://en.miui.com/download-332.html | grep $romsite"/"$miuidate"/"miui_HMNote5AGlobal_$miuidate_)
if [ "$ugg_global" != "" ] ; then
export HMNote5AGlobal=$(echo $ugg_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote5AGlobal && echo Url= $romsite"/"$miuidate"/"$HMNote5AGlobal
fi
echo "ugg: China"
ugg_china=$(curl -s http://en.miui.com/download-332.html#488 | grep $romsite"/"$miuidate"/"miui_HMNote5A_$miuidate_)
if [ "$ugg_china" != "" ] ; then
export HMNote5A=$(echo $ugg_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote5A && echo Url= $romsite"/"$miuidate"/"$HMNote5A
fi
echo "ugglite: Global"
ugglite_global=$(curl -s http://en.miui.com/download-332.html#487 | grep $romsite"/"$miuidate"/"miui_HMNote5ALITEGlobal_$miuidate_)
if [ "$ugglite_global" != "" ] ; then
export HMNote5ALITEGlobal=$(echo $ugglite_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote5ALITEGlobal && echo Url= $romsite"/"$miuidate"/"$HMNote5ALITEGlobal
fi
echo "ugglite: China"
ugglite_china=$(curl -s http://en.miui.com/download-332.html#489 | grep $romsite"/"$miuidate"/"miui_HMNote5ALITE_$miuidate_)
if [ "$ugglite_china" != "" ] ; then
export HMNote5ALITE=$(echo $ugglite_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote5ALITE && echo Url= $romsite"/"$miuidate"/"$HMNote5ALITE
fi
echo "vince: China"
vince_china=$(curl -s http://en.miui.com/download-340.html | grep $romsite"/"$miuidate"/"miui_HM5Plus_$miuidate_)
if [ "$vince_china" != "" ] ; then
export HM5Plus=$(echo $vince_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM5Plus && echo Url= $romsite"/"$miuidate"/"$HM5Plus
fi

# Downloading
wget -qq --progress=bar https://github.com/xiaomi-firmware-updater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
echo "Working on aqua_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI4s && ./$extract $MI4s && rm $MI4s
echo "Working on cappu_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIPAD3 && ./$extract $MIPAD3 && rm $MIPAD3
echo "Working on capricorn_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5SGlobal && ./$extract $MI5SGlobal && rm $MI5SGlobal
echo "Working on capricorn_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5S && ./$extract $MI5S && rm $MI5S
echo "Working on chiron_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMIX2Global && ./$extract $MIMIX2Global && rm $MIMIX2Global
echo "Working on chiron_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMIX2 && ./$extract $MIMIX2 && rm $MIMIX2
echo "Working on gemini_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5Global && ./$extract $MI5Global && rm $MI5Global
echo "Working on gemini_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5 && ./$extract $MI5 && rm $MI5
echo "Working on helium_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMAX652Global && ./$extract $MIMAX652Global && rm $MIMAX652Global
echo "Working on helium_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMAX652 && ./$extract $MIMAX652 && rm $MIMAX652
echo "Working on hydrogen_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMAXGlobal && ./$extract $MIMAXGlobal && rm $MIMAXGlobal
echo "Working on hydrogen_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMAX && ./$extract $MIMAX && rm $MIMAX
echo "Working on ido_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM3Global && ./$extract $HM3Global && rm $HM3Global
echo "Working on ido_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM3 && ./$extract $HM3 && rm $HM3
echo "Working on jason_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MINote3 && ./$extract $MINote3 && rm $MINote3
echo "Working on kenzo_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote3ProGlobal && ./$extract $HMNote3ProGlobal && rm $HMNote3ProGlobal
echo "Working on kenzo_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote3Pro && ./$extract $HMNote3Pro && rm $HMNote3Pro
echo "Working on kate_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote3ProtwGlobal && ./$extract $HMNote3ProtwGlobal && rm $HMNote3ProtwGlobal
echo "Working on land_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM3SGlobal && ./$extract $HM3SGlobal && rm $HM3SGlobal
echo "Working on land_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM3S && ./$extract $HM3S && rm $HM3S
echo "Working on libra_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI4c && ./$extract $MI4c && rm $MI4c
echo "Working on lithium_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMIXGlobal && ./$extract $MIMIXGlobal && rm $MIMIXGlobal
echo "Working on lithium_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMIX && ./$extract $MIMIX && rm $MIMIX
echo "Working on markw_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM4Pro && ./$extract $HM4Pro && rm $HM4Pro
echo "Working on mido_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote4XGlobal && ./$extract $HMNote4XGlobal && rm $HMNote4XGlobal
echo "Working on mido_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote4X && ./$extract $HMNote4X && rm $HMNote4X
echo "Working on natrium_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5SPlusGlobal && ./$extract $MI5SPlusGlobal && rm $MI5SPlusGlobal
echo "Working on natrium_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5SPlus && ./$extract $MI5SPlus && rm $MI5SPlus
echo "Working on nikel_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote4Global && ./$extract $HMNote4Global && rm $HMNote4Global
echo "Working on nikel_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote4 && ./$extract $HMNote4 && rm $HMNote4
echo "Working on omega_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMPro && ./$extract $HMPro && rm $HMPro
echo "Working on oxygen_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMAX2Global && ./$extract $MIMAX2Global && rm $MIMAX2Global
echo "Working on oxygen_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MIMAX2 && ./$extract $MIMAX2 && rm $MIMAX2
echo "Working on prada_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM4 && ./$extract $HM4 && rm $HM4
echo "Working on riva_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM5A && ./$extract $HM5A && rm $HM5A
echo "Working on rolex_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM4AGlobal && ./$extract $HM4AGlobal && rm $HM4AGlobal
echo "Working on rolex_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM4A && ./$extract $HM4A && rm $HM4A
echo "Working on rosy_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM5 && ./$extract $HM5 && rm $HM5
echo "Working on sagit_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI6Global && ./$extract $MI6Global && rm $MI6Global
echo "Working on sagit_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI6 && ./$extract $MI6 && rm $MI6
echo "Working on santoni_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM4XGlobal && ./$extract $HM4XGlobal && rm $HM4XGlobal
echo "Working on santoni_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM4X && ./$extract $HM4X && rm $HM4X
echo "Working on scorpio_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MINote2Global && ./$extract $MINote2Global && rm $MINote2Global
echo "Working on scorpio_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MINote2 && ./$extract $MINote2 && rm $MINote2
echo "Working on tiffany_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$MI5X && ./$extract $MI5X && rm $MI5X
echo "Working on ugg_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote5AGlobal && ./$extract $HMNote5AGlobal && rm $HMNote5AGlobal
echo "Working on ugg_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote5A && ./$extract $HMNote5A && rm $HMNote5A
echo "Working on ugglite_global"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote5ALITEGlobal && ./$extract $HMNote5ALITEGlobal && rm $HMNote5ALITEGlobal
echo "Working on ugglite_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HMNote5ALITE && ./$extract $HMNote5ALITE && rm $HMNote5ALITE
echo "Working on vince_china"
wget -qq --progress=bar $romsite"/"$miuidate"/"$HM5Plus && ./$extract $HM5Plus && rm $HM5Plus

#Uploading
curl -T "{$(echo *.zip | tr ' ' ',')}" ftp://uploads.androidfilehost.com//xiaomi-firmware-updates/$miuidate/ --user $afhuser:$afhpass
curl -T "{$(echo *.zip | tr ' ' ',')}" ftp://basketbuild.com//xiaomi-firmware-updates/$miuidate/ --user $basketbuilduser:$basketbuildpass
