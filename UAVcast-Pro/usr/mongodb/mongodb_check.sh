#!/bin/bash

LOCK_FILE=/var/lib/mongodb/mongod.lock
PID_FILE=/var/run/mongodb/mongo.pid
DAEMON=/usr/bin/mongod
DBPATH=/var/lib/mongodb

mongo_running=0

if [ -f $PID_FILE ]; then
  pid=`cat $PID_FILE`
  if ps -p $pid > /dev/null
  then
    mongo_running=1
  fi
fi

if [ $mongo_running == 1 ]; then
  echo "Mongo already running pid:$pid"
  exit 0
fi

echo "Mongo is not running. Starting to repair."

sudo service mongodb stop

if [ -f $LOCK_FILE ]; then
  echo -n "Removing lock_file:$LOCK_FILE..."
  sudo rm $LOCK_FILE
fi

echo "Repairing mongo db at $DBPATH..."
$DAEMON --repair --dbpath $DBPATH 
sudo chown -R mongodb:mongodb $DBPATH
sudo service mongodb start
echo "done."


