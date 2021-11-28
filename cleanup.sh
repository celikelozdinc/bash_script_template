#! /bin/bash

set -o errexit  # fail-fast
set -o pipefail # when using pipes

current_dir=$(dirname "$(readlink --canonicalize-existing "${0}" 2> /dev/null)")
readonly conf_file="${current_dir}/conf.env"
readonly utility_file="${current_dir}/utility.sh"
readonly error_no_such_configuration_file_found=17
readonly error_no_such_container_found=41


source "${utility_file}"

# Read configuration file
if [ ! -f "${conf_file}" ] ; then
    smooth_exit \
        "error reading configuration file : ${conf_file}" \
        "${error_no_such_configuration_file_found}"
fi

source "${conf_file}"

disk_usage_report "BEFORE"

sudo apt clean
sudo apt-get clean
sudo journalctl --rotate
sudo journalctl --vacuum-time="${VACUUM_TIME}"

# Report docker usage : https://medium.com/geekculture/checklist-for-a-clean-efficient-developer-workstation-4a000c83073e
docker_resource_usage_report

echo "Pruning docker build cache..."
docker builder prune --all --force

# # Clean exited docker containers if any
if [ "$(docker ps -aq)" ]; then
    clean_exited_containers
fi


disk_usage_report "AFTER"