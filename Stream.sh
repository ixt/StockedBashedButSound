SOURCE='https://finance.google.com/finance?q=INDEXFTSE:UKX&ei=xUvKWbmuIoTKU4yNpZgM'

while true; do
    VALUE=$(lynx --dump -width 1025 $SOURCE | head -36 | tail -1 | sed -e "s/,//g" | xargs echo)
    FREQ=$(echo "($VALUE / 4000)*162" | bc -l)
    killall screen
    screen -dm speaker-test -t sine -f $FREQ
    echo $FREQ
    sleep 0.2
done
