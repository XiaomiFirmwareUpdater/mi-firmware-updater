#!/bin/bash
# Export Variables
export romsite="http://bigota.d.miui.com"
extract="create_flashable_firmware.sh"
export miuiver="V$(curl -s http://en.miui.com/download.html | grep version | cut -d '"' -f 52 | cut -c 5)" && echo "Latest miui update is $miuiver"

# Fetch Updates
echo "aqua: China"
aqua_china=$(curl -s http://en.miui.com/download-300.html | grep miui_MI4s_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$aqua_china" != "" ] ; then
export MI4s=$(echo $aqua_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI4s && echo Url= $aqua_china
fi
echo "cappu: China"
cappu_china=$(curl -s http://en.miui.com/download-325.html | grep miui_MIPAD3_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$cappu_china" != "" ] ; then
export MIPAD3=$(echo $cappu_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIPAD3 && echo Url= $cappu_china
fi
echo "capricorn: Global"
capricorn_global=$(curl -s http://en.miui.com/download-314.html | grep miui_MI5SGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$capricorn_global" != "" ] ; then
export MI5SGlobal=$(echo $capricorn_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5SGlobal && echo Url= $capricorn_global
fi
echo "capricorn: China"
capricorn_china=$(curl -s http://en.miui.com/download-314.html#456 | grep miui_MI5S_$miuiver| cut -d '"' -f 6 | head -n1)
if [ "$capricorn_china" != "" ] ; then
export MI5S=$(echo $capricorn_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5S && echo Url= $capricorn_china
fi
echo "chiron: Global"
chiron_global=$(curl -s http://en.miui.com/download-334.html | grep miui_MIMIX2Global_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$chiron_global" != "" ] ; then
export MIMIX2Global=$(echo $chiron_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMIX2Global && echo Url= $chiron_global
fi
echo "chiron: China"
chiron_china=$(curl -s http://en.miui.com/download-334.html#492 | grep miui_MIMIX2_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$chiron_china" != "" ] ; then
export MIMIX2=$(echo $chiron_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMIX2 && echo Url= $chiron_china
fi
echo "gemini: Global"
gemini_global=$(curl -s http://en.miui.com/download-299.html | grep miui_MI5Global_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$gemini_global" != "" ] ; then
export MI5Global=$(echo $gemini_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5Global && echo Url= $gemini_global
fi
echo "gemini: China"
gemini_china=$(curl -s http://en.miui.com/download-299.html#435 | grep miui_MI5_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$gemini_china" != "" ] ; then
export MI5=$(echo $gemini_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5 && echo Url= $gemini_china
fi
echo "helium: Global"
helium_global=$(curl -s http://en.miui.com/download-302.html#446 | grep miui_MIMAX652Global_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$helium_global" != "" ] ; then
export MIMAX652Global=$(echo $helium_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX652Global && echo Url= $helium_global
fi
echo "helium: China"
helium_china=$(curl -s http://en.miui.com/download-302.html#458 | grep miui_MIMAX652_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$helium_china" != "" ] ; then
export MIMAX652=$(echo $helium_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX652 && echo Url= $helium_china
fi
echo "hydrogen: Global"
hydrogen_global=$(curl -s http://en.miui.com/download-302.html#450 | grep miui_MIMAXGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$hydrogen_global" != "" ] ; then
export MIMAXGlobal=$(echo $hydrogen_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAXGlobal && echo Url= $hydrogen_global
fi
echo "hydrogen: China"
hydrogen_china=$(curl -s http://en.miui.com/download-302.html#445 | grep miui_MIMAX_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$hydrogen_china" != "" ] ; then
export MIMAX=$(echo $hydrogen_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX && echo Url= $hydrogen_china
fi
echo "ido: Global"
ido_global=$(curl -s http://en.miui.com/download-298.html | grep miui_HM3Global_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$ido_global" != "" ] ; then
export HM3Global=$(echo $ido_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM3Global && echo Url= $ido_global
fi
echo "ido: China"
ido_china=$(curl -s http://en.miui.com/download-298.html#433 | grep miui_HM3_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$ido_china" != "" ] ; then
export HM3=$(echo $ido_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM3 && echo Url= $ido_china
fi
echo "jason: China"
jason_china=$(curl -s http://en.miui.com/download-336.html#495 | grep miui_MINote3_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$jason_china" != "" ] ; then
export MINote3=$(echo $jason_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MINote3 && echo Url= $jason_china
fi
echo "kenzo: Global"
kenzo_global=$(curl -s http://en.miui.com/download-301.html | grep miui_HMNote3ProGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$kenzo_global" != "" ] ; then
export HMNote3ProGlobal=$(echo $kenzo_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote3ProGlobal && echo Url= $kenzo_global
fi
echo "kenzo: China"
kenzo_china=$(curl -s http://en.miui.com/download-301.html#439 | grep miui_HMNote3Pro_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$kenzo_china" != "" ] ; then
export HMNote3Pro=$(echo $kenzo_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote3Pro && echo Url= $kenzo_china
fi
echo "kate: Global"
kate_global=$(curl -s http://en.miui.com/download-301.html#449 | grep miui_HMNote3ProtwGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$kate_global" != "" ] ; then
export HMNote3ProtwGlobal=$(echo $kate_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote3ProtwGlobal && echo Url= $kate_global
fi
echo "land: Global"
land_global=$(curl -s http://en.miui.com/download-303.html | grep miui_HM3SGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$land_global" != "" ] ; then
export HM3SGlobal=$(echo $land_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM3SGlobal && echo Url= $land_global
fi
echo "land: China"
land_china=$(curl -s http://en.miui.com/download-303.html#447 | grep miui_HM3S_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$land_china" != "" ] ; then
export HM3S=$(echo $land_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM3S && echo Url= $land_china
fi
echo "libra: China"
libra_china=$(curl -s http://en.miui.com/download-293.html | grep miui_MI4c_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$libra_china" != "" ] ; then
export MI4c=$(echo $libra_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI4c && echo Url= $libra_china
fi
echo "lithium: Global"
lithium_global=$(curl -s http://en.miui.com/download-317.html | grep miui_MIMIXGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$lithium_global" != "" ] ; then
export MIMIXGlobal=$(echo $lithium_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMIXGlobal && echo Url= $lithium_global
fi
echo "lithium: China"
lithium_china=$(curl -s http://en.miui.com/download-317.html#460 | grep miui_MIMIX_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$lithium_china" != "" ] ; then
export MIMIX=$(echo $lithium_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMIX && echo Url= $lithium_china
fi
echo "markw: China"
markw_china=$(curl -s http://en.miui.com/download-320.html#466 | grep miui_HM4Pro_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$markw_china" != "" ] ; then
export HM4Pro=$(echo $markw_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4Pro && echo Url= $markw_china
fi
echo "mido: Global"
mido_global=$(curl -s http://en.miui.com/download-309.html#468 | grep miui_HMNote4XGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$mido_global" != "" ] ; then
export HMNote4XGlobal=$(echo $mido_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote4XGlobal && echo Url= $mido_global
fi
echo "mido: China"
mido_china=$(curl -s http://en.miui.com/download-321.html#469 | grep miui_HMNote4X_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$mido_china" != "" ] ; then
export HMNote4X=$(echo $mido_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote4X && echo Url= $mido_china
fi
echo "natrium: Global"
natrium_global=$(curl -s http://en.miui.com/download-315.html | grep miui_MI5SPlusGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$natrium_global" != "" ] ; then
export MI5SPlusGlobal=$(echo $natrium_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5SPlusGlobal && echo Url= $natrium_global
fi
echo "natrium: China"
natrium_china=$(curl -s http://en.miui.com/download-315.html#457 | grep miui_MI5SPlus_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$natrium_china" != "" ] ; then
export MI5SPlus=$(echo $natrium_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5SPlus && echo Url= $natrium_china
fi
echo "nikel: Global"
nikel_global=$(curl -s http://en.miui.com/download-309.html | grep miui_HMNote4Global_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$nikel_global" != "" ] ; then
export HMNote4Global=$(echo $nikel_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote4Global && echo Url= $nikel_global
fi
echo "nikel: China"
nikel_china=$(curl -s http://en.miui.com/download-309.html#454 | grep miui_HMNote4_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$nikel_china" != "" ] ; then
export HMNote4=$(echo $nikel_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote4 && echo Url= $nikel_china
fi
echo "omega: China"
omega_china=$(curl -s http://en.miui.com/download-304.html | grep miui_HMPro_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$omega_china" != "" ] ; then
export HMPro=$(echo $omega_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMPro && echo Url= $omega_china
fi
echo "oxygen: Global"
oxygen_global=$(curl -s http://en.miui.com/download-328.html | grep miui_MIMAX2Global_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$oxygen_global" != "" ] ; then
export MIMAX2Global=$(echo $oxygen_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX2Global && echo Url= $oxygen_global
fi
echo "oxygen: China"
oxygen_china=$(curl -s http://en.miui.com/download-328.html#482 | grep miui_MIMAX2_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$oxygen_china" != "" ] ; then
export MIMAX2=$(echo $oxygen_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MIMAX2 && echo Url= $oxygen_china
fi
echo "prada: China"
prada_china=$(curl -s http://en.miui.com/download-318.html#461 | grep miui_HM4_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$prada_china" != "" ] ; then
export HM4=$(echo $prada_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4 && echo Url= $prada_china
fi
echo "riva: China"
riva_china=$(curl -s http://en.miui.com/download-338.html#499 | grep miui_HM5A_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$riva_china" != "" ] ; then
export HM5A=$(echo $riva_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM5A && echo Url= $riva_china
fi
echo "rolex: Global"
rolex_global=$(curl -s http://en.miui.com/download-319.html | grep miui_HM4AGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$rolex_global" != "" ] ; then
export HM4AGlobal=$(echo $rolex_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4AGlobal && echo Url= $rolex_global
fi
echo "rolex: China"
rolex_china=$(curl -s http://en.miui.com/download-319.html#462 | grep miui_HM4A_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$rolex_china" != "" ] ; then
export HM4A=$(echo $rolex_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4A && echo Url= $rolex_china
fi
echo "rosy: China"
rosy_china=$(curl -s http://en.miui.com/download-340.html#505 | grep miui_HM5_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$rosy_china" != "" ] ; then
export HM5=$(echo $rosy_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM5 && echo Url= $rosy_china
fi
echo "sagit: Global"
sagit_global=$(curl -s http://en.miui.com/download-326.html | grep miui_MI6Global_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$sagit_global" != "" ] ; then
export MI6Global=$(echo $sagit_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI6Global && echo Url= $sagit_global
fi
echo "sagit: China"
sagit_china=$(curl -s http://en.miui.com/download-326.html#481 | grep miui_MI6_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$sagit_china" != "" ] ; then
export MI6=$(echo $sagit_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI6 && echo Url= $sagit_china
fi
echo "santoni: Global"
santoni_global=$(curl -s http://en.miui.com/download-323.html | grep miui_HM4XGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$santoni_global" != "" ] ; then
export HM4XGlobal=$(echo $santoni_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4XGlobal && echo Url= $santoni_global
fi
echo "santoni: China"
santoni_china=$(curl -s http://en.miui.com/download-323.html#476 | grep miui_HM4X_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$santoni_china" != "" ] ; then
export HM4X=$(echo $santoni_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM4X && echo Url= $santoni_china
fi
echo "scorpio: Global"
scorpio_global=$(curl -s http://en.miui.com/download-316.html | grep miui_MINote2Global_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$scorpio_global" != "" ] ; then
export MINote2Global=$(echo $scorpio_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MINote2Global && echo Url= $scorpio_global
fi
echo "scorpio: China"
scorpio_china=$(curl -s http://en.miui.com/download-316.html#459 | grep miui_MINote2_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$scorpio_china" != "" ] ; then
export MINote2=$(echo $scorpio_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MINote2 && echo Url= $scorpio_china
fi
echo "tiffany: China"
tiffany_china=$(curl -s http://en.miui.com/download-329.html | grep miui_MI5X_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$tiffany_china" != "" ] ; then
export MI5X=$(echo $tiffany_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MI5X && echo Url= $tiffany_china
fi
echo "ugg: Global"
ugg_global=$(curl -s http://en.miui.com/download-332.html | grep miui_HMNote5AGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$ugg_global" != "" ] ; then
export HMNote5AGlobal=$(echo $ugg_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote5AGlobal && echo Url= $ugg_global
fi
echo "ugg: China"
ugg_china=$(curl -s http://en.miui.com/download-332.html#488 | grep miui_HMNote5A_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$ugg_china" != "" ] ; then
export HMNote5A=$(echo $ugg_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote5A && echo Url= $ugg_china
fi
echo "ugglite: Global"
ugglite_global=$(curl -s http://en.miui.com/download-332.html#487 | grep miui_HMNote5ALITEGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$ugglite_global" != "" ] ; then
export HMNote5ALITEGlobal=$(echo $ugglite_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote5ALITEGlobal && echo Url= $ugglite_global
fi
echo "ugglite: China"
ugglite_china=$(curl -s http://en.miui.com/download-332.html#489 | grep miui_HMNote5ALITE_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$ugglite_china" != "" ] ; then
export HMNote5ALITE=$(echo $ugglite_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HMNote5ALITE && echo Url= $ugglite_china
fi
echo "vince: China"
vince_china=$(curl -s http://en.miui.com/download-340.html | grep miui_HM5Plus_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$vince_china" != "" ] ; then
export HM5Plus=$(echo $vince_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $HM5Plus && echo Url= $vince_china
fi
echo "virgo: Global"
virgo_global=$(curl -s http://en.miui.com/download-262.html | grep miui_MINoteGlobal_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$virgo_global" != "" ] ; then
export MINoteGlobal=$(echo $virgo_global | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MINoteGlobal && echo Url= $virgo_global
fi
echo "virgo: China"
virgo_china=$(curl -s http://en.miui.com/download-262.html#395 | grep miui_MINote_$miuiver | cut -d '"' -f 6 | head -n1)
if [ "$virgo_china" != "" ] ; then
export MINote=$(echo $virgo_china | cut -d "/" -f 5 | cut -d '"' -f 1 | tee )
echo File Name= $MINote && echo Url= $virgo_china
fi

# Downloading
wget -qq --progress=bar https://github.com/xiaomi-firmware-updater/xiaomi-flashable-firmware-creator/raw/master/create_flashable_firmware.sh && chmod +x create_flashable_firmware.sh
echo "Working on aqua_china"
wget -qq --progress=bar $aqua_china && ./$extract $MI4s && rm $MI4s
echo "Working on cappu_china"
wget -qq --progress=bar $cappu_china && ./$extract $MIPAD3 && rm $MIPAD3
echo "Working on capricorn_global"
wget -qq --progress=bar $capricorn_global && ./$extract $MI5SGlobal && rm $MI5SGlobal
echo "Working on capricorn_china"
wget -qq --progress=bar $capricorn_china && ./$extract $MI5S && rm $MI5S
echo "Working on chiron_global"
wget -qq --progress=bar $chiron_global && ./$extract $MIMIX2Global && rm $MIMIX2Global
echo "Working on chiron_china"
wget -qq --progress=bar $chiron_china && ./$extract $MIMIX2 && rm $MIMIX2
echo "Working on gemini_global"
wget -qq --progress=bar $gemini_global && ./$extract $MI5Global && rm $MI5Global
echo "Working on gemini_china"
wget -qq --progress=bar $gemini_china && ./$extract $MI5 && rm $MI5
echo "Working on helium_global"
wget -qq --progress=bar $helium_global && ./$extract $MIMAX652Global && rm $MIMAX652Global
echo "Working on helium_china"
wget -qq --progress=bar $helium_china && ./$extract $MIMAX652 && rm $MIMAX652
echo "Working on hydrogen_global"
wget -qq --progress=bar $hydrogen_global && ./$extract $MIMAXGlobal && rm $MIMAXGlobal
echo "Working on hydrogen_china"
wget -qq --progress=bar $hydrogen_china && ./$extract $MIMAX && rm $MIMAX
echo "Working on ido_global"
wget -qq --progress=bar $ido_global && ./$extract $HM3Global && rm $HM3Global
echo "Working on ido_china"
wget -qq --progress=bar $ido_china && ./$extract $HM3 && rm $HM3
echo "Working on jason_china"
wget -qq --progress=bar $jason_china && ./$extract $MINote3 && rm $MINote3
echo "Working on kenzo_global"
wget -qq --progress=bar $kenzo_global && ./$extract $HMNote3ProGlobal && rm $HMNote3ProGlobal
echo "Working on kenzo_china"
wget -qq --progress=bar $kenzo_china && ./$extract $HMNote3Pro && rm $HMNote3Pro
echo "Working on kate_global"
wget -qq --progress=bar $kate_global && ./$extract $HMNote3ProtwGlobal && rm $HMNote3ProtwGlobal
echo "Working on land_global"
wget -qq --progress=bar $land_global && ./$extract $HM3SGlobal && rm $HM3SGlobal
echo "Working on land_china"
wget -qq --progress=bar $land_china && ./$extract $HM3S && rm $HM3S
echo "Working on libra_china"
wget -qq --progress=bar $libra_china && ./$extract $MI4c && rm $MI4c
echo "Working on lithium_global"
wget -qq --progress=bar $lithium_global && ./$extract $MIMIXGlobal && rm $MIMIXGlobal
echo "Working on lithium_china"
wget -qq --progress=bar $lithium_china && ./$extract $MIMIX && rm $MIMIX
echo "Working on markw_china"
wget -qq --progress=bar $markw_china && ./$extract $HM4Pro && rm $HM4Pro
echo "Working on mido_global"
wget -qq --progress=bar $mido_global && ./$extract $HMNote4XGlobal && rm $HMNote4XGlobal
echo "Working on mido_china"
wget -qq --progress=bar $mido_china && ./$extract $HMNote4X && rm $HMNote4X
echo "Working on natrium_global"
wget -qq --progress=bar $natrium_global && ./$extract $MI5SPlusGlobal && rm $MI5SPlusGlobal
echo "Working on natrium_china"
wget -qq --progress=bar $natrium_china && ./$extract $MI5SPlus && rm $MI5SPlus
echo "Working on nikel_global"
wget -qq --progress=bar $nikel_global && ./$extract $HMNote4Global && rm $HMNote4Global
echo "Working on nikel_china"
wget -qq --progress=bar $nikel_china && ./$extract $HMNote4 && rm $HMNote4
echo "Working on omega_china"
wget -qq --progress=bar $omega_china && ./$extract $HMPro && rm $HMPro
echo "Working on oxygen_global"
wget -qq --progress=bar $oxygen_global && ./$extract $MIMAX2Global && rm $MIMAX2Global
echo "Working on oxygen_china"
wget -qq --progress=bar $oxygen_china && ./$extract $MIMAX2 && rm $MIMAX2
echo "Working on prada_china"
wget -qq --progress=bar $prada_china && ./$extract $HM4 && rm $HM4
echo "Working on riva_china"
wget -qq --progress=bar $riva_china && ./$extract $HM5A && rm $HM5A
echo "Working on rolex_global"
wget -qq --progress=bar $rolex_global && ./$extract $HM4AGlobal && rm $HM4AGlobal
echo "Working on rolex_china"
wget -qq --progress=bar $rolex_china && ./$extract $HM4A && rm $HM4A
echo "Working on rosy_china"
wget -qq --progress=bar $rosy_china && ./$extract $HM5 && rm $HM5
echo "Working on sagit_global"
wget -qq --progress=bar $sagit_global && ./$extract $MI6Global && rm $MI6Global
echo "Working on sagit_china"
wget -qq --progress=bar $sagit_china && ./$extract $MI6 && rm $MI6
echo "Working on santoni_global"
wget -qq --progress=bar $santoni_global && ./$extract $HM4XGlobal && rm $HM4XGlobal
echo "Working on santoni_china"
wget -qq --progress=bar $santoni_china && ./$extract $HM4X && rm $HM4X
echo "Working on scorpio_global"
wget -qq --progress=bar $scorpio_global && ./$extract $MINote2Global && rm $MINote2Global
echo "Working on scorpio_china"
wget -qq --progress=bar $scorpio_china && ./$extract $MINote2 && rm $MINote2
echo "Working on tiffany_china"
wget -qq --progress=bar $tiffany_china && ./$extract $MI5X && rm $MI5X
echo "Working on ugg_global"
wget -qq --progress=bar $ugg_global && ./$extract $HMNote5AGlobal && rm $HMNote5AGlobal
echo "Working on ugg_china"
wget -qq --progress=bar $ugg_china && ./$extract $HMNote5A && rm $HMNote5A
echo "Working on ugglite_global"
wget -qq --progress=bar $ugglite_global && ./$extract $HMNote5ALITEGlobal && rm $HMNote5ALITEGlobal
echo "Working on ugglite_china"
wget -qq --progress=bar $ugglite_china && ./$extract $HMNote5ALITE && rm $HMNote5ALITE
echo "Working on vince_china"
wget -qq --progress=bar $vince_china && ./$extract $HM5Plus && rm $HM5Plus
echo "Working on virgo_global"
wget -qq --progress=bar $virgo_global && ./$extract $MINoteGlobal && rm $MINoteGlobal
echo "Working on virgo_china"
wget -qq --progress=bar $virgo_china && ./$extract $MINote && rm $MINote

#Uploading
wput *zip ftp://$basketbuilduser:$basketbuildpass@basketbuild.com//Stable/$miuiver/
wput *zip ftp://$afhuser:$afhpass@uploads.androidfilehost.com//Stable/$miuiver/
