#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
##
## This file is controlled by systemd
##

case "$1" in
    stop)
        $DIR/script/./DroneCode.cast stopmavlink 
        ;;
    *)
	    #Start UAVcast-Pro init function
        $DIR/script/./DroneCode.cast start 
esac