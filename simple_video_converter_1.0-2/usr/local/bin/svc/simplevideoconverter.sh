#!/bin/bash
#
# Title: Simple Video Converter
# Author: Robert Smith
# Description: Simple video converter that takes in a video file and supplies options 
# to convert to a few other formats. For example mp4 and mkv. 
#
# Show the intro to the application 
intro_window=$(zenity --question --title="Video Format Converter" \
        --width="400" \
        --height="300" \
        --text="This is a simple video converter that uses ffmpeg and has options to convert to a couple file formats. I hope you enjoy" \
        --ok-label="Next" \
        --cancel-label="Cancel")
# Check if the user clicked next or cancel
if [[ $? -eq 1 ]]; then
    echo "Process cancelled";
    exit 0;
fi
#
#
# Get the file that we intend to convert
#
while true;
do
file_to_convert="$(zenity --file-selection --title="Select File To Convert")"

    case $? in 
        1)
            echo "No file was selected"
            exit $?;;
        -1)  
            echo "An unexpected error has occurred."
            exit $?;;
    esac
#
# Let the user pick the file extension to convert to
#
convert_to_file_ext=$(zenity --list --title="Convert to Format" \
        --width=200 \
        --height=200 \
        --ok-label="Next" \
        --cancel-label="Cancel" \
        --column='File Extension' "mp4" "mkv")
#
# Let the user pick the directory to save the file into
#
location_to_convert_to="$(zenity --file-selection --directory --title="Select Save Directory")"

    case $? in 
        1)
            echo "No file was selected"
            exit $?;;
        -1)  
            echo "An unexpected error has occurred."
            exit $?;;
    esac
#
# User should name the file converted
#
converted_filename="$(zenity --forms --title="Converted File Name" \
        --width="200" \
        --height="200" \
        --add-entry="Converted File Name:" \
        --ok-label="Next" \
        --cancel-label="Cancel")"

    case $? in 
        1)
            exit $?;;
        -1)
            exit $?;;
    esac
#
#
echo $converted_filename
echo ${#converted_filename}



if [[ -z "$converted_filename" ]]; then 
    original_filename=${file_to_convert##*/};

    ffmpeg -i "$file_to_convert" -c copy "$location_to_convert_to/${original_filename%.*}.$convert_to_file_ext" | \
        zenity --width="500" --title="Conversion in progress" --text="Please wait while your video is converted..." \
                --progress --pulsate --auto-close;
else

    ffmpeg -i "$file_to_convert" -c copy "$location_to_convert_to/$converted_filename.$convert_to_file_ext" | \
        zenity --width="500" --title="Conversion in progress" --text="Please wait while your video is converted..." \
                --progress --pulsate --auto-close;
fi
#
# Check if we are successful and if not then we need to show an error.
# Exit with the appropriate status.
#
if [[ $? -ne 1 ]]; then 
    zenity --info --title="Video saved $location_to_convert_to/$coverted_filename.$convert_to_file_ext!" --text="Files have been updated";
else
    zenity --error --title="We are sorry your file could not be converted please try again later...";
fi


continue_working="$(zenity --question --title="Keep working?" \
        --text="Would you like to do another one?" \
        --width="200" \
        --height="200" \
        --ok-label="Sure" \
        --cancel-label="No, I'm done")"

if [[ $? -eq 1 ]]; then 
    exit 0;
fi

done