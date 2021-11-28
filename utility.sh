#! /bin/bash

smooth_exit() {
    local -r message="${1}" # local readonly variable
    local -r code="${2}"    # local readonly variable
    echo "${message}" >&2
    exit "${code}"
}


docker_resource_usage_report() {
    echo "*********************************"
    echo "Printing docker resource state : "
    sleep 1
    docker system df
    echo "*********************************"
}

disk_usage_report() {
    when="${1}"
    echo "*****************************************************"
    if [[ "${when}" == "AFTER" ]]; then
        echo "Disk usage report AFTER housekeeping activities: "
    elif [[ ${when} == "BEFORE" ]]; then
        echo "Disk usage report BEFORE housekeeping activities: "
    fi
    sleep 1
    df -h
    echo "*****************************************************"
}


clean_exited_containers() {
    echo "*************************************"
    echo "Cleaning exited docker containers : "
    sleep 1
    docker ps -aq | awk '{print $1}' | xargs docker rm -f
    #docker container prune
    echo "*************************************"
}