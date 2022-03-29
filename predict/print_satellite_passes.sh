#!/bin/bash
array=("NOAA 19" "NOAA 18" "NOAA 15" "METEOR-M 2")
echo "Satellite |  Pass | Elevation |  Duration (s)"

midnight=$(date -d "$today 0" +%s)

for SAT in "${array[@]}"; do

    PREDICTION_START=$(/usr/local/bin/predict -t /home/ubuntu/weather_sat/predict/weather.tle -p "${SAT}" $midnight | head -1)
    PREDICTION_END=$(/usr/local/bin/predict -t /home/ubuntu/weather_sat/predict/weather.tle -p "${SAT}" $midnight | tail -1)

    var2=$(echo $PREDICTION_END | cut -d " " -f 1)

    MAXELEV=$(/usr/local/bin/predict -t /home/ubuntu/weather_sat/predict/weather.tle -p "${SAT}" | awk -v max=0 '{if($5>max){max=$5}}END{print max}')
    while [ $(date --date="TZ=\"UTC\" @${var2}" +%D) == $(date +%D) ]; do

        START_TIME=$(echo $PREDICTION_START | cut -d " " -f 3-4)
        var1=$(echo $PREDICTION_START | cut -d " " -f 1)

        var3=$(echo $START_TIME | cut -d " " -f 2 | cut -d ":" -f 3)

        TIMER=$(expr $var2 - $var1 + $var3)
    
        OUTDATE=$(TZ=CET date --date="TZ=\"UTC\" $START_TIME" +"%a %d %B %Y - %H:%M:%S CET")

        if [ $MAXELEV -gt 19 ]; then
            echo ${SAT//" "/} " | " ${OUTDATE} "|" $MAXELEV "|" $TIMER
        fi

        nextpredict=$(expr $var2 + 60)

        PREDICTION_START=$(/usr/local/bin/predict -t /home/ubuntu/weather_sat/predict/weather.tle -p "${SAT}" $nextpredict | head -1)
        PREDICTION_END=$(/usr/local/bin/predict -t /home/ubuntu/weather_sat/predict/weather.tle -p "${SAT}" $nextpredict | tail -1)

        MAXELEV=$(/usr/local/bin/predict -t /home/ubuntu/weather_sat/predict/weather.tle -p "${SAT}" $nextpredict | awk -v max=0 '{if($5>max){max=$5}}END{print max}')

        var2=$(echo $PREDICTION_END | cut -d " " -f 1)
    done

done
