perl -pi -e 's/{anonymous_user_creation, false}/{anonymous_user_creation, true}/g' /etc/riak-cs/app.config

riak start
sleep 2
stanchion start
sleep 2
riak-cs start

sleep 5

curl -sS -H 'Content-Type: application/json' -X POST http://localhost:8080/riak-cs/user --data '{"email":"jeff@jeffutter.com", "name":"admin user"}' > /admin_user.json
KEY=`cat /admin_user.json | grep -E -o '"key_id":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`
SECRET=`cat /admin_user.json | grep -E -o '"key_secret":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`

echo "Admin Key: "$KEY
echo "Admin Secret: "$SECRET

riak-cs stop
stanchion stop
riak stop

sleep 3

perl -pi -e 's/###KEY###/'$KEY'/g' /etc/riak/app.config
perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/riak/app.config

perl -pi -e 's/###KEY###/'$KEY'/g' /etc/riak-cs/app.config
perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/riak-cs/app.config

perl -pi -e 's/###KEY###/'$KEY'/g' /etc/riak-cs-control/app.config
perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/riak-cs-control/app.config

perl -pi -e 's/###KEY###/'$KEY'/g' /etc/stanchion/app.config
perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/stanchion/app.config

perl -pi -e 's/{anonymous_user_creation, true}/{anonymous_user_creation, false}/g' /etc/riak-cs/app.config
