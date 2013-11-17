#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}

killz(){
	echo "Killing all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker kill
	echo $ids | xargs docker rm
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker stop
	echo $ids | xargs docker rm
}

install(){
	echo "Installing docker registry and images:"
	cp /vagrant/etc/docker.conf /etc/init/docker.conf

	./build_push.sh
}

start(){
	zookeeper/start
	kafka/start
	riak-cs/start
	shipyard/start	

	sleep 1
}

update(){
	apt-get update
	apt-get install -y lxc-docker

	docker pull relateiq/zookeeper
	docker pull relateiq/redis
	docker pull relateiq/kafka
	docker pull internal_registry:5000/riak-cs	
	docker pull shipyard/shipyard
}

case "$1" in
	restart)
		killz
		start
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status|ssh}"
		RETVAL=1
esac
