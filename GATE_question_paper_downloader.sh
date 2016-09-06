#!/bin/bash
#	Created By : Vishwa Prakash H V
#	Created on : 04-sep-2016
#	Description:
#	This app is designed to download previous year gate question papers "in bulk"
#	from http://gate.iitm.ac.in/ (IIT Madras).	 
#
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


#Function to Dwonload
download()
{
	cd $path
	mkdir -p temp-gqpd
	cd temp-gqpd
	for ((i=0;i<${#subject[@]};i++)); do
		cd $path/temp-gqpd
		mkdir -p ${subject[$i]}
		cd ${subject[$i]}
		for ((j=0;j<${#year[@]};j++)); do
			wget --continue --tries=0 --progress=bar --show-progress --output-document ${subject[$i]}_${year[$j]}.pdf "http://gate.iitm.ac.in/gateqps/${year[$j]}/${subject[$i]}.pdf"\
			2>&1| awk '{for (i=1;i<=NF;i++) if($i~/\%/) {sub(/\%/,"",$i);print $i;system("")}}' |\
			zenity --progress --height=20 --width=400 --text="Downloading ${subject[$i]} of ${year[$j]}..." --title="Downloading..." --auto-close --percentage=0 --time-remaining\
			--height=200 --width=300
			
			if [ $? -eq 1 ]; then
				return
			fi
			# fflush("") or fflush() or system("") can be used for dynamically flushing buffer contents to zenity 
		done
	done
}

clean()
{	
	# Deleting empty files (man wget section -O)
	find $path/temp-gqpd -empty -type f -delete
	#Deleting empty directories
	find $path/temp-gqpd -empty -type d -delete
	#Moving to original Directory
	cp -r $path/temp-gqpd/* $path
	rm -r $path/temp-gqpd
	
}

zenity --info --ok-label="Got it" --height=20 --title="Please Note" --text="In 2015, Some papers were split into more than one papers.\n\nExample : CS was made as CS1 , CS2 , CS3"

#wget --tries=0 --continue http://gate.iitm.ac.in/gateqps/2015/ae.pdf
selection=$(zenity  --height=500 --width=550 --ok-label="Next"\
					--title="Select papers"\
					--text='<span foreground="grey">Select one or more subjects</span>'\
					--list --checklist --separator="|" --column "Pick" --column "paper" \
FALSE  "AE - Aerospace Engineering"  \
FALSE  "AG - Agricultural Engineering"  \
FALSE  "AR - Architecture and Planning"  \
FALSE  "BT - Biotechnology"  \
FALSE  "CE - Civil Engineering"  \
FALSE  "CE1 - Civil Engineering"  \
FALSE  "CH - Chemical Engineering"  \
FALSE  "CS - Computer Science and Information Technology"  \
FALSE  "CS1 - Computer Science and Information Technology"  \
FALSE  "CS2 - Computer Science and Information Technology"  \
FALSE  "CS3 - Computer Science and Information Technology"  \
FALSE  "CY - Chemistry "  \
FALSE  "EC - Electronics and Communication Engineering"  \
FALSE  "EC1 - Electronics and Communication Engineering"  \
FALSE  "EC2 - Electronics and Communication Engineering"  \
FALSE  "EC3 - Electronics and Communication Engineering"  \
FALSE  "EE - Electrical Engineering"  \
FALSE  "EE1 - Electrical Engineering"  \
FALSE  "EE2 - Electrical Engineering"  \
FALSE  "EY - Ecology and Evolution"  \
FALSE  "GA1 - GENERAL APTITUDE"  \
FALSE  "GA2 - GENERAL APTITUDE"  \
FALSE  "GA3 - GENERAL APTITUDE"  \
FALSE  "GA4 - GENERAL APTITUDE"  \
FALSE  "GA5 - GENERAL APTITUDE"  \
FALSE  "GA6 - GENERAL APTITUDE"  \
FALSE  "GA7 - GENERAL APTITUDE"  \
FALSE  "GA8 - GENERAL APTITUDE"  \
FALSE  "GG - Geology and Geophysics"  \
FALSE  "IN - Instrumentation Engineering"  \
FALSE  "MA - Mathematics"  \
FALSE  "ME - Mechanical Engineering"  \
FALSE  "ME1 - Mechanical Engineering"  \
FALSE  "ME2 - Mechanical Engineering"  \
FALSE  "ME3 - Mechanical Engineering"  \
FALSE  "MN - Mining Engineering"  \
FALSE  "MT - Metallurgical Engineering"  \
FALSE  "PH - Physics"  \
FALSE  "PI - Production and Industrial Engineering"  \
FALSE  "TF - Textile Engineering and Fibre Science"  \
FALSE  "XE - Engineering Sciences"  \
FALSE  "XE_a - Engineering Sciences"  \
FALSE  "vXE_b - Engineering Sciences"  \
FALSE  "XE_c - Engineering Sciences"  \
FALSE  "XE_c_DATA - Engineering Sciences"  \
FALSE  "XE_d - Engineering Sciences"  \
FALSE  "XE_e - Engineering Sciences"  \
FALSE  "XE_f - Engineering Sciences"  \
FALSE  "XE_g - Engineering Sciences"  \
FALSE  "XL - Life Sciences"  \
FALSE  "XL_h - Life Sciences"  \
FALSE  "XL_i - Life Sciences"  \
FALSE  "XL_j - Life Sciences"  \
FALSE  "XL_k - Life Sciences"  \
FALSE  "XL_l - Life Sciences"  \
FALSE  "XL_m - Life SciencesFALSE")
#FALSE  "ALL - ALL PAPERS (SELECT ALL)"  \

status_subj_sel=$?
subject=($(echo $selection | sed 's/|/\n/g' | awk -F" - " '{printf "%s\n",tolower($1)}'))


#	If "Calcel"/"X" is clicked
if [ $status_subj_sel -eq 1 ] ; then
	exit 1
fi

#	If no subject selected
if [ ${#subject[@]} -eq 0 ]; then
	zenity --warning --title="No items selected" --text="No items were selected. exiting..."\
			--height=80 --width=300 --timeout=3
	exit 1
fi

if [ $status_subj_sel -eq 0 -a ${#subject[@]} -ne 0 ]; then
year=($(zenity  --height=360 --width=300 --ok-label="Select destination"\
		--title="Select year"\
		--text='<span foreground="grey">Select year</span>'\
		--list --checklist --column "pick" --column "year"  $( for ((i=2015;i>=2007;i--)) ; do echo -en "FALSE $i "; done )\
		--separator=" "))
		
		status_year_sel=$?
		
		if [ $status_year_sel -eq 1 ] ; then
			exit 1
		fi
		
		if [ ${#year[@]} -eq 0 ]; then
			zenity --warning --title="No items selected" --text="No items were selected. exiting..."\
			--height=80 --width=300 --timeout=3
			exit 1
		fi
		
		path=$(zenity --file-selection --directory)
		
		if [ $? -ne 0 ]; then
			exit $?
		fi
		
		ping -c 2 8.8.8.8 >/dev/null
		if [ $? -ne 0 ] ; then
			zenity --error --title="No Internet" --text="No Internet access\nPlease make sure you have active internet connection"\
			--ellipsize
			exit $?
		fi
		download
		clean
fi
