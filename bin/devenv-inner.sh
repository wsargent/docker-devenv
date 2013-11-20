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

	/vagrant/bin/install.sh
}

push() {
	echo "Pushing images to registry:"
	
	/vagrant/bin/push.sh
}

start(){
    echo "Starting containers"

	cd /vagrant/containers

	internal_registry/start
	zookeeper/start
	kafka/start
	riak-cs/start
	shipyard/start	

	sleep 1
}

update() {
	apt-get update
	apt-get install -y lxc-docker

    /vagrant/bin/update.sh
}

imp() {
    echo "Importing registry: DISABLED as import seems to miss CMD in the image"
	# /vagrant/bin/import-repo.sh
}

exp() {
    echo "Exporting registry:"
	/vagrant/bin/export-repo.sh
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
    install)
        install
        ;;
    push)
		push
		;;
	imp)
		imp
		;;
	exp)
		exp
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status|ssh|install|push|imp|exp}"
		RETVAL=1
esac
