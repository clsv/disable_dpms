#!/bin/bash
dpmsOff()
{
    xset s off
	xset -dpms
}
dpmsOn()
{
    xset s on
    xset +dpms
}

checkScreen()
{
    #FullScreen window detect
    win_id_list=`xprop -root _NET_CLIENT_LIST | sed -e 's/.*\#//g' | sed 's/\,/ /g'`
    for win_id in $win_id_list
    do
        #get windows state
        WinFullScreen=`DISPLAY=:0 xprop -id $win_id | grep _NET_WM_STATE_FULLSCREEN`
        if [[ "$WinFullScreen" = *NET_WM_STATE_FULLSCREEN* ]];then
            return 1
        fi
    done
    #flashplayer detect
    if [ -n "`pgrep -f flashplayer.so`" ] || [ -n "`pgrep -f pepperflash.so`" ] ;then
        return 1
	fi
    return 0
}


echo $result

while pgrep -f "Xorg" > /dev/null; do
    checkScreen
    result=$?
    if [[ $result -eq 1 ]]; then
        dpmsOff
    else
        dpmsOn
    fi
    sleep 60
done
