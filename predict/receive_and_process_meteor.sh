#! /bin/bash
# $1 = Satellite Name
# $2 = Frequency
# $3 = FileName base
# $4 = TLE File
# $5 = EPOC start time
# $6 = Time to capture

cd /home/ubuntu/weather_sat

# timeout $6 predict/rtlsdr_m2_lrpt_rx.py $1 $2 raw_files/$3
timeout $6 predict/airspy_m2_lrpt_rx.py $1 $2 raw_files/$3

# Winter
#medet/medet_arm raw_files/${3}.s raw_files/$3 -r 68 -g 65 -b 64 -na -S

# Summer
medet/medet_arm raw_files/${3}.s images/$3 -r 66 -g 65 -b 64 -na -S

rm raw_files/${3}.s

if [ -f "images/${3}_0.bmp" ]; then
	dte=`date +%H`
	# Winter
	#convert images/${3}_1.bmp images/${3}_1.bmp images/${3}_0.bmp -combine -set colorspace sRGB images/${3}.bmp
    #convertimages/ ${3}_2.bmp images/${3}_2.bmp images/${3}_2.bmp -combine -set colorspace sRGB -negate images/${3}_ir.bmp

	# Summer
	convert images/${3}_2.bmp images/${3}_1.bmp images/${3}_0.bmp -combine -set colorspace sRGB images/${3}.bmp

	meteor_rectify/rectify.py images/${3}.bmp

	# Winter only
	#meteor_rectify/rectify.py images/${3}_ir.bmp

	# Rotate evening images 180 degrees
	if [ $dte -lt 13 ]; then
		convert images/${3}-rectified.png -normalize -quality 90 images/$3.jpg
        # Winter only
		#convert images/${3}_ir-rectified.png -normalize -quality 90 images/${3}_ir.jpg
	else
		convert images/${3}-rectified.png -rotate 180 -normalize -quality 90 images/$3.jpg
		# Winter only
		#convert images/${3}_ir-rectified.png -rotate 180 -normalize -quality 90 images/${3}_ir.jpg
	fi

	rm images/$3.bmp
	rm images/${3}_0.bmp
	rm images/${3}_1.bmp
	rm images/${3}_2.bmp
	# rm images/${3}-rectified.png

	# Winter only
	#rm images/${3}_ir.bmp
	#rm images/${3}_ir-rectified.png
fi