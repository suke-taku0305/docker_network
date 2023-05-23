#! /bin/bash


docker run -td --net none --name route1\
	--rm --privileged --hostname route1\
	slankdev/frr
PID=`docker inspect route1 --format '{{.State.Pid}}'`
ln -s /proc/$PID/ns/net /var/run/netns/route1

docker run -td --net none --name route2\
	--rm --privileged --hostname route2\
	slankdev/frr
PID=`docker inspect route2 --format '{{.State.Pid}}'`
ln -s /proc/$PID/ns/net /var/run/netns/route2
