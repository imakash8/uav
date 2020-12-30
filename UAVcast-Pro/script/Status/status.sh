#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# grab monogdb documents
DATABASE=$(mongo uavcast --eval "JSON.stringify(db.configuration.find().toArray())" --quiet)

MODEM_DATABASE=$(jq -r '.[] | select(._id | contains("modem"))' <<<$DATABASE)
FC_DATABASE=$(jq -r '.[] | select(._id | contains("flightcontroller"))' <<<$DATABASE)
VPN_DATABASE=$(jq -r '.[] | select(._id | contains("vpn"))' <<<$DATABASE)

mavproxy=false

INTERFACE=''
Status(){
        UNDERVOLTAGE=$( vcgencmd get_throttled )
        MODEMTYPE=$(jq -r '.MM_Model' <<<"$MODEM_DATABASE")
        MODEMSTICKINTERFACE=$(jq -r '.MM_stick_interface' <<<"$MODEM_DATABASE")
        MODEMHILINKINTERFACE=$(jq -r '.MM_hilink_interface' <<<"$MODEM_DATABASE")

        # systemctl active
        if systemctl is-active --quiet UAVcast
        then
                systemdActive=true
        else
                systemdActive=false
        fi

        # systemctl enabled
        if systemctl is-enabled --quiet UAVcast
        then
                systemdEnable=true
        else
                systemdEnable=false
        fi

        # MMcli modem connected
        if [[ $MODEMTYPE == "Stick" ]]; then
                if [[ $MODEMSTICKINTERFACE == "custom" ]]; then
                        INTERFACE=$(jq -r '.MM_stick_interface_custom' <<<"$MODEM_DATABASE")
                else
                        INTERFACE="$MODEMSTICKINTERFACE"
                fi
                if [[ $INTERFACE != '' ]]; then
                        if ping -q -c 1 -W 1 8.8.8.8 -I "$INTERFACE" >/dev/null;
                        then
                                modem=true
                        else
                                modem=false
                        fi
                fi
        else
                if [[ $MODEMHILINKINTERFACE == "custom" ]]; then
                        INTERFACE=$(jq -r '.MM_hilink_interface_custom' <<<"$MODEM_DATABASE")
                else
                        INTERFACE="$MODEMHILINKINTERFACE"
                fi
                if [[ $INTERFACE != '' ]]; then
                        if ping -q -c 1 -W 1 8.8.8.8 -I "$INTERFACE" >/dev/null;
                        then
                                modem=true
                        else
                                modem=false
                        fi
                fi
        fi
        # picamera
        if vcgencmd get_camera | grep -q detected=1;
        then
                picamera=true
        else
                picamera=false
        fi

        if pgrep -x "gst-launch-1.0" > /dev/null
        then
                gstreamer=true
        else
                gstreamer=false
        fi

        #VPN
        case "$(jq -r '.vpn_type' <<<"$VPN_DATABASE")" in
                "ZeroTier")
                        sudo zerotier-cli listnetworks $(jq -r '.vpn_zt_id' <<<"$VPN_DATABASE") | grep 'OK' > /dev/null 2>&1
                                if [[ $? == 0 ]];
                                then
                                        vpn=true
                                else
                                        vpn=false
                                fi
                ;;
                "Openvpn")
                         ip a show tun0 up  >/dev/null
                                if [[ $? == 0 ]];
                                then
                                        vpn=true
                                else
                                        vpn=false
                                fi
                ;;
                 "NM_Openvpn")
                         ip a show tun0 up  >/dev/null
                                if [[ $? == 0 ]];
                                then
                                        vpn=true
                                else
                                        vpn=false
                                fi
                ;;
                 *)
                 vpn=false
        esac
}

Status
jq -n "{mavproxy:\"$mavproxy\", picamera:\"$picamera\", gstreamer:\"$gstreamer\", modem:\"$modem\", systemdActive:\"$systemdActive\", systemdEnable:\"$systemdEnable\", vpn:\"$vpn\", undervoltage:\"$UNDERVOLTAGE\"}"
