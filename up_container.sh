## Check META config
set -ue

mount_docker_netns () {
  if [ $# -ne 2 ]; then
    echo "Usage: $0 <container> <netns>"
    exit 1
  fi
  mkdir -p /var/run/netns
  PID=`docker inspect $1 -f "{{.State.Pid}}"`
  ln -s /proc/$PID/ns/net /var/run/netns/$2
}


kokobr () {
  if [ $# -ne 3 ]; then
    echo "Usage: $0 <bridge> <container> <ifname>"
    exit 1
  fi
  mount_docker_netns $2 $2
  ip link add name $3 type veth peer name $2$3
  ip link set dev $3 netns $2
  ip link set $2$3 up
  ip netns exec $2 ip link set $3 up
  ip netns del $2
  ovs-vsctl add-port $1 $2$3
}


kokobr_netns () {
  if [ $# -ne 3 ]; then
    echo "Usage: $0 <bridge> <netns> <ifname>"
    exit 1
  fi
  ip link add name $3 type veth peer name $2$3
  ip link set dev $3 netns $2
  ip link set $2$3 up
  ip netns exec $2 ip link set $3 up
  ovs-vsctl add-port $1 $2$3
}


koko_physnet () {
if [ $# -ne 2 ]; then
  echo "Usage: $0 <container> <netif>"
  exit 1
fi
mount_docker_netns $1 $1
ip link set dev $2 netns $1
ip netns exec $1 ip link set $2 up
ip netns del $1
}


#####################
# PRE-INIT COMMANDS #
#####################

#####################
# INIT COMMANDS #
#####################

# generate nodes
docker run -td --hostname router1 --net none --name router1 --rm --privileged  -v /tmp/tinet:/tinet  slankdev/frr
docker run -td --hostname router2 --net none --name router2 --rm --privileged  -v /tmp/tinet:/tinet  slankdev/frr
docker run -td --hostname router3 --net none --name router3 --rm --privileged  -v /tmp/tinet:/tinet  slankdev/frr
docker run -td --hostname hostA --net none --name hostA --rm --privileged  -v /tmp/tinet:/tinet  slankdev/frr
docker run -td --hostname hostB --net none --name hostB --rm --privileged  -v /tmp/tinet:/tinet  slankdev/frr

# connect router1 to hostA
mount_docker_netns router1 router1
mount_docker_netns hostA hostA
ip link add net0 netns router1 type veth peer name net0 netns hostA
ip netns exec router1 ip link set net0 up
ip netns exec hostA ip link set net0 up
ip netns del router1
ip netns del hostA

# connect router1 to router2
mount_docker_netns router1 router1
mount_docker_netns router2 router2
ip link add net1 netns router1 type veth peer name net0 netns router2
ip netns exec router1 ip link set net1 up
ip netns exec router2 ip link set net0 up
ip netns del router1
ip netns del router2

# connect router2 to router3
mount_docker_netns router2 router2
mount_docker_netns router3 router3
ip link add net1 netns router2 type veth peer name net0 netns router3
ip netns exec router2 ip link set net1 up
ip netns exec router3 ip link set net0 up
ip netns del router2
ip netns del router3

# connect router3 to hostB
mount_docker_netns router3 router3
mount_docker_netns hostB hostB
ip link add net1 netns router3 type veth peer name net0 netns hostB
ip netns exec router3 ip link set net1 up
ip netns exec hostB ip link set net0 up
ip netns del router3
ip netns del hostB

#####################
# POST-INIT COMMANDS #
#####################
