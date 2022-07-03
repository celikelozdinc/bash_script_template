#! /bin/bash

smooth_exit() {
    local -r message="${1}" # local readonly variable
    local -r code="${2}"    # local readonly variable
    echo "${message}" >&2
    exit "${code}"
}


docker_resource_usage_report() {
    log="${1}"
    echo "*****************************************************" | tee --append "${log}"
    echo "Printing docker resource state : " | tee --append "${log}"
    sleep 1
    docker system df >> "${log}" 2>&1
    echo "*****************************************************" | tee --append "${log}"
}

disk_usage_report() {
    when="${1}"
    log="${2}"
    echo "*****************************************************" | tee --append "${log}"
    sleep 1
    if [[ "${when}" == "AFTER" ]]; then
        echo "Disk usage report AFTER housekeeping activities: " | tee --append "${log}"
    elif [[ ${when} == "BEFORE" ]]; then
        curr=$(date)
        export Greeter="Execution on ""${curr}"
        echo "${Greeter}" >& "${log}" # Overwrite
        echo "Disk usage report BEFORE housekeeping activities: " | tee --append "${log}"
    fi
    df -h >> "${log}" 2>&1 # Append
    echo "*****************************************************" | tee --append "${log}"
}


clean_exited_containers() {
    echo "*************************************"
    echo "Cleaning exited docker containers : "
    sleep 1
    docker ps -aq | awk '{print $1}' | xargs docker rm -f
    #docker container prune
    echo "*************************************"
}

empty_trash() {
    echo "********************"
    echo "Will empty trash :"
    # Needs `sudo apt install -y trash-cli`
    # https://github.com/andreafrancia/trash-cli
    trash-empty 7
    echo "********************"
}