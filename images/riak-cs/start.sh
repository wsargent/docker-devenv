#!/bin/bash

# start SSH
/usr/sbin/sshd

riak start
sleep 2
stanchion start
riak-cs start
riak-cs-control start

KEY=`cat /admin_user.json | grep -E -o '"key_id":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`
SECRET=`cat /admin_user.json | grep -E -o '"key_secret":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`

echo "Admin Key: "$KEY
echo "Admin Secret: "$SECRET

# keep script in foreground
while(true) do
  sleep 60
done
