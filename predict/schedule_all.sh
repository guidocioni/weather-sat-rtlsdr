#!/bin/bash

# Update Satellite Information

wget -qr https://www.celestrak.com/NORAD/elements/weather.txt -O /home/ubuntu/weather_sat/predict/weather.txt
grep "NOAA 15" /home/ubuntu/weather_sat/predict/weather.txt -A 2 > /home/ubuntu/weather_sat/predict/weather.tle
grep "NOAA 18" /home/ubuntu/weather_sat/predict/weather.txt -A 2 >> /home/ubuntu/weather_sat/predict/weather.tle
grep "NOAA 19" /home/ubuntu/weather_sat/predict/weather.txt -A 2 >> /home/ubuntu/weather_sat/predict/weather.tle
grep "METEOR-M 2" /home/ubuntu/weather_sat/predict/weather.txt -A 2 >> /home/ubuntu/weather_sat/predict/weather.tle



#Remove all AT jobs

for i in `atq | awk '{print $1}'`;do atrm $i;done


#Schedule Satellite Passes:

/home/ubuntu/weather_sat/predict/schedule_satellite.sh "NOAA 19" 137.1000
/home/ubuntu/weather_sat/predict/schedule_satellite.sh "NOAA 18" 137.9125
/home/ubuntu/weather_sat/predict/schedule_satellite.sh "NOAA 15" 137.6200
/home/ubuntu/weather_sat/predict/schedule_satellite.sh "METEOR-M 2" 137.1000