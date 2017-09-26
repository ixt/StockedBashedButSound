#!/bin/bash
SOURCE='https://finance.google.com/finance?q='
do_tone(){
        stock=$1
        url="LON:$stock"
        lynx --dump -width 1025 $SOURCE$url > .$stock
        REALNUM=$(sed -n '/[+-][0-9]*\./=' .$stock | head -1)
        VALUE=$(head -$REALNUM .$stock | tail -1 | xargs echo | cut -d' ' -f1)
        if [ "$VALUE" = "Sometimes" ]; then
            echo "Captcha catch!" &2>&1
            exit 1
        fi
        if [ "$VALUE" = "README.md stocklist Stream.sh" ]; then 
            FREQ="261.63"
        else 
            FREQ=$(echo "261.63 $VALUE" | bc -l)
        fi
        screen -S $stock -dm speaker-test -t sine -f $FREQ
        echo $REALNUM : $FREQ $stock $VALUE &2>&1
        if [ "$VALUE" != "0.00" ]; then 
            sleep $(echo $VALUE | sed -e "s/[+-]//g")
        fi
        screen -S $stock -X quit
}

while true; do
    while read stock; do
        CATCH=$(do_tone $stock &)
        if [[ $CATCH = "Captcha catch!" ]]; then
            echo $CATCH
            exit 1 
        else
            echo $CATCH
        fi
        sleep 0.1
    done < stocklist
    wait
done
