#!/bin/bash

usage() {
  echo "Usage: $0 [ -c number_of_concurrent_process ] [ -d directory_depth ] [chmod or chown] [user:group or 644] /path_to_directory " 1>&2
  exit 1
}

# arguments
cmd=$5
cmd_opt=$6
directory_path=$7

while getopts ":c:d:" options; do

    case "${options}" in
        c)
        input_core=${OPTARG}
        ;;
        d)
        directory_depth=${OPTARG}
        ;;
        *)
        usage
        ;;
    esac
done

#check chmod or chown command
if [ "$(echo $cmd | egrep -o "chmod|chown")" = "" ]
then
    usage
fi

#check if path exists
if ! [ -d "$directory_path" ]
then
    usage
fi

#check command exists
command_list="nproc find sort sed screen"
function check_command(){
    for cmds in $command_list
    do 
        if ! command -v $cmds &> /dev/null
        then
            echo "$cmds could not be found"
            exit
        fi
    done
}
check_command

# Get cpu core count
function check_cpu_core_count(){
    core_count=$(nproc)
    if (( $input_core > $core_count )); then
        echo "core count should be less than or equal to $core_count"
        exit 1
    fi
}
check_cpu_core_count

# Get list of directories
list_of_directories=$(find /home/alok/Downloads/cryfs -maxdepth $directory_depth -type d | sort | sed -z 's|\n|,|g;s|,$|\n|')

# Convert String to Array
OLD_IFS=$IFS
IFS=","
for i in $list_of_directories
do
    list_of_directories_array+=("$i")
done

IFS="$OLD_IFS"

# run commands in background
for i in $(seq 0 $((${#list_of_directories_array[@]}-1)))
do
    if [ "$(echo ${list_of_directories_array[$i+1]} | grep -o "${list_of_directories_array[$i]}" )" = "${list_of_directories_array[$i]}" ]
    then
        screen -A -m -d $cmd $cmd_opt "${list_of_directories_array[$i]}"
        screen -A -m -d $cmd $cmd_opt "${list_of_directories_array[$i]}"/*
    else
        screen -A -m -d $cmd -R $cmd_opt "${list_of_directories_array[$i]}"
    fi
    # check background running process status
    while(true)
    do
        screen_process_count=$(ps -ef | grep SCREE[N] | grep $cmd | wc -l)
        if (( $screen_process_count >= $input_core ))
        then
            sleep 0.2
            echo "$screen_process_count screen process is running in background...Do not close..."
        else
            echo "$i screen command sent to background...Do not close..."
            break
        fi
    done
    
done

# check for remaning background running process status
while(true)
do
    screen_process_count=$(ps -ef | grep SCREE[N] | grep $cmd | wc -l)
    if (( $screen_process_count > 0 ))
    then
        sleep 2
        echo "$screen_process_count screen process is running in background...Do not close..."
    else
        echo "all screen command completed..."
        break
    fi
done