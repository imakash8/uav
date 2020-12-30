#!/bin/sh

. spinner.sh

while getopts "f d" opt; do
    case "$opt" in
    f)  FORCEINSTALL="true";;
    d)  DEVELOPMENT="true";;
    esac
done

PROGNAME=$(basename $0)
error_exit()
{

#	----------------------------------------------------------------
#	Function for exit due to fatal program error
#		Accepts 1 argument:
#			string containing descriptive error message
#	----------------------------------------------------------------
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    exit_failure $? 1
    if [ $FORCEINSTALL == "false" ]; then
    echo "An error occurd. You can try to force the installation by adding -f on the installer."
    echo "Example::  ./install -f"
    exit 1
    fi
}
