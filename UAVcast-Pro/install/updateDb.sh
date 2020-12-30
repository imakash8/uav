#!/bin/bash
# Force update in database with new values.
DATABASE=$(mongo uavcast --eval "JSON.stringify(db.configuration.find().toArray())" --quiet)
EVENTDATABASE=$(mongo uavcast --eval "JSON.stringify(db.eventlog-settings.find().toArray())" --quiet)
FC_DATABASE=$(jq -r '.[] | select(._id | contains("flightcontroller"))' <<<$DATABASE)


mavVersion=$(jq -r '.mavVersion' <<<"$FC_DATABASE");
eventlogenabled=$(jq -r '.enable' <<<"$EVENTDATABASE");
telem_internal_address_gpio=$(jq -r '.telem_internal_address_gpio' <<<"$FC_DATABASE");
telem_internal_address_usb=$(jq -r '.telem_internal_address_usb' <<<"$FC_DATABASE");
telem_protocol=$(jq -r '.telem_protocol' <<<"$FC_DATABASE");
telem_baudrate=$(jq -r '.telem_baudrate' <<<"$FC_DATABASE");
connection_type=$(jq -r '.connection_type' <<<"$FC_DATABASE");
Cntrl=$(jq -r '.Cntrl' <<<"$FC_DATABASE");

if [ -z "$mavVersion" ] || [ "$mavVersion" == "null" ]; then
 mongo uavcast --eval 'db.configuration.update({"_id":"flightcontroller"}, {$set:{ "mavVersion" : 2 }}, {upsert:true} )' --quiet
fi

if [ -z "$telem_internal_address_gpio" ] || [ "$telem_internal_address_gpio" == "null" ]; then
 mongo uavcast --eval 'db.configuration.update({"_id":"flightcontroller"}, {$set:{ "telem_internal_address_gpio": "/dev/ttyAMA0" }}, {upsert:true} )' --quiet
fi

if [ -z "$telem_internal_address_usb" ] || [ "$telem_internal_address_usb" == "null" ]; then
 mongo uavcast --eval 'db.configuration.update({"_id":"flightcontroller"}, {$set:{ "telem_internal_address_usb" : "/dev/ttyACM0" }}, {upsert:true} )' --quiet
fi

if [ -z "$telem_protocol" ] || [ "$telem_protocol" == "null" ]; then
 mongo uavcast --eval 'db.configuration.update({"_id":"flightcontroller"}, {$set:{ "telem_protocol" : "udp" }}, {upsert:true} )' --quiet
fi

if [ -z "$telem_baudrate" ] || [ "$telem_baudrate" == "null" ]; then
 mongo uavcast --eval 'db.configuration.update({"_id":"flightcontroller"}, {$set:{ "telem_baudrate" : "57600" }}, {upsert:true} )' --quiet
fi

if [ -z "$connection_type" ] || [ "$connection_type" == "null" ]; then
 mongo uavcast --eval 'db.configuration.update({"_id":"flightcontroller"}, {$set:{ "connection_type" : "usb" }}, {upsert:true} )' --quiet
fi

if [ -z "$Cntrl" ] || [ "$Cntrl" == "null" ]; then
 mongo uavcast --eval 'db.configuration.update({"_id":"flightcontroller"}, {$set:{ "Cntrl" : "APM" }}, {upsert:true} )' --quiet
fi

if [ -z "$eventlogenabled" ] || [ "$eventlogenabled" == "null" ]; then
 mongo uavcast --eval 'db.eventlog-settings.update({"_id":"settings"}, {$set:{ "enable" : true }}, {upsert:true} )' --quiet
fi


